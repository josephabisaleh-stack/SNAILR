class LlmResponseJob < ApplicationJob
  queue_as :default

  TITLE_PROMPT = <<~PROMPT
    Generate a short, clear title in English (max 6 words) that captures the user's goal.
    Reply with ONLY the title, nothing else. No quotes, no punctuation at the end.
    Examples:
    - User: "Je veux apprendre à coder" → Learn to Code
    - User: "I want to run a marathon" → Run a Marathon
    - User: "Perdre 10kg avant l'été" → Lose 10kg Before Summer
  PROMPT

  SYSTEM_PROMPT = <<~PROMPT
    You are an elite Performance Coach. Transform the user's objective into exactly 5 concrete steps.

    Reply with ONLY a valid JSON array — no markdown, no explanation, nothing else.
    Format:
    [
      {
        "position": 1,
        "title": "Short step title",
        "xp_reward": 20,
        "goal": "Clear, measurable definition of success",
        "obstacle": "One potential blocker",
        "quick_fix": "Strategy to overcome the obstacle"
      }
    ]

    Rules:
    - xp_reward across all 5 steps must total exactly 100
    - Each step needs a measurable goal, one obstacle, and a quick_fix
    - Steps must be actionable and time-bound
    - Answer in the same language as the user
    - Output ONLY the JSON array, no other text
  PROMPT

  def perform(chat_id, user_message_id)
    chat = Chat.find(chat_id)
    objective = chat.objective
    user_message = Message.find(user_message_id)

    if objective.title.blank?
      title_response = RubyLLM.chat(model: "gpt-4o-mini").with_instructions(TITLE_PROMPT).ask(user_message.content)
      objective.update!(title: title_response.content.strip.delete('"'))
    end

    ruby_llm_chat = RubyLLM.chat(model: "gpt-4o-mini").with_instructions(SYSTEM_PROMPT)

    chat.messages.order(:created_at).where.not(id: user_message.id).each do |msg|
      ruby_llm_chat.ask(msg.content) if msg.role == "user"
    end

    response = ruby_llm_chat.ask(user_message.content)
    steps_json = JSON.parse(response.content.strip)

    objective.steps.destroy_all
    steps_json.each do |step_data|
      objective.steps.create!(
        position:  step_data["position"],
        title:     step_data["title"],
        xp_reward: step_data["xp_reward"],
        goal:      step_data["goal"],
        obstacle:  step_data["obstacle"],
        quick_fix: step_data["quick_fix"],
        done:      false
      )
    end

    Turbo::StreamsChannel.broadcast_replace_to(
      objective,
      target: "spiral-section",
      partial: "objectives/spiral",
      locals: { objective: objective, steps: objective.steps.sorted }
    )

    Message.create!(role: "assistant", content: response.content, chat: chat)
  end
end
