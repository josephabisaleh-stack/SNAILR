class ObjectivesController < ApplicationController
  before_action :set_objective, only: %i[show confirm destroy]

  JSON_EXTRACTION_PROMPT = <<~PROMPT
    Extract the steps from the coaching plan below and return ONLY a valid JSON array with no extra text, markdown, or explanation.
    Each step heading looks like: ### 🏁 Step 1 — [Step title here]
    The "title" is the descriptive name AFTER the dash (—), not "Step 1" or the emoji.
    Each object must have exactly these keys:
    - "title": the descriptive step name after the "—" (e.g. "Build a Daily Reading Habit"), never "Step 1"
    - "xp_reward": the XP value as an integer (extract the number from "XP Reward: XX XP")
    - "goal": the text after "Goal:" (string)
    - "obstacle": the text after "Obstacle:" (string)
    - "quick_fix": the text after "Quick-fix:" (string)

    Example output:
    [{"title":"Build a Daily Reading Habit","xp_reward":20,"goal":"Read 20 pages every day for 30 days","obstacle":"Lack of time","quick_fix":"Read during commute or before bed"}]
  PROMPT
  def new
  end

  def index
    @objectives = current_user.objectives.order(created_at: :desc).includes(chat: :messages)
    @youtube_links = build_youtube_links(@objectives)
  end

  def show
    @chat = @objective.chat
    @message = @chat.messages.new if @chat
    @steps = @objective.steps
  end

  # def edit
  # end

  def confirm
    last_message = @objective.chat.messages.where(role: "assistant").order(:created_at).last
    json_response = RubyLLM.chat(model: "gpt-4o-mini").with_instructions(JSON_EXTRACTION_PROMPT).ask(last_message.content)
    steps_data = JSON.parse(json_response.content.gsub(/```json|```/, "").strip)

    steps_data.each_with_index do |step, i|
      @objective.steps.create!(
        position: i + 1,
        title: step["title"],
        xp_reward: step["xp_reward"],
        goal: step["goal"],
        obstacle: step["obstacle"],
        quick_fix: step["quick_fix"]
      )
    end

    @objective.in_progress!
    redirect_to objective_path(@objective)
  end

  # def update
  #   if @objective.update(objective_params)
  #     redirect_to objective_path(@objective), notice: "Objective updated."
  #   else
  #     render :edit, status: :unprocessable_content
  #   end
  # end

  def destroy
    @objective.destroy
    redirect_to objectives_path, notice: "Objective deleted."
  end

  private

  def set_objective
    @objective = current_user.objectives.find(params[:id])
  end

  def build_youtube_links(objectives)
    objectives.each_with_object({}) do |objective, hash|
      next unless objective.chat

      last_msg = objective.chat.messages.select { |m| m.role == "assistant" }.last
      next unless last_msg

      urls = last_msg.content.scan(/https?:\/\/(?:www\.)?youtube\.com\/watch\?v=[\w-]+/)
      hash[objective.id] = urls if urls.any?
    end
  end

  # def objective_params
  #   params.expect(objective: %i[title description])
  # end
end
