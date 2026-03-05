class Objective < ApplicationRecord
  belongs_to :user
  has_many :steps, dependent: :destroy
  has_one :chat, dependent: :destroy

  enum :status, {
    in_creation: "in_creation",
    in_progress: "in_progress",
    completed: "completed"
  }

  validates :progress, numericality: { in: 0..100 }

  after_update :create_steps_from_last_message, if: lambda {
    saved_change_to_status?(from: "in_creation", to: "in_progress")
  }

  private

  def create_steps_from_last_message
    last_message = chat&.messages&.order(created_at: :asc)&.last
    return unless last_message

    steps_json = extract_steps_as_json(last_message.content)
    return unless steps_json.is_a?(Array)

    steps_json.each.with_index(1) do |step_data, index|
      steps.create!(
        title: step_data["title"],
        xp_reward: step_data["xp_reward"] || 10,
        position: step_data["position"] || index
      )
    end
  end

  def extract_steps_as_json(content)
    llm_chat = RubyLLM.chat

    prompt = <<~PROMPT
      Extract all steps from the following content and return them as a JSON array.
      Each step object must have these keys:
      - "title": the step title (string, without the "Step N -" prefix)
      - "xp_reward": the XP reward value (integer, default to 10 if not found)
      - "position": the step number (integer)

      Return ONLY a valid JSON array with no additional text or markdown.

      Content:
      #{content}
    PROMPT

    response = llm_chat.ask(prompt)
    JSON.parse(response.content)
  rescue JSON::ParserError => e
    Rails.logger.error("Failed to parse steps JSON from LLM: #{e.message}")
    nil
  end
end
