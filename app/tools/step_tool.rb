class StepTool < RubyLLM::Tool
  description "Creates or updates one step for the user's objective. Call this tool exactly 5 times, once per step."

  param :position,   desc: "Step position 1-5 (integer)", type: :integer
  param :title,      desc: "Short descriptive step title"
  param :xp_reward,  desc: "XP reward for this step (integer, all 5 steps must total 100)", type: :integer
  param :goal,       desc: "Clear, measurable definition of success"
  param :obstacle,   desc: "One potential blocker"
  param :quick_fix,  desc: "Strategy to overcome the obstacle"

  def initialize(objective_id:)
    @objective_id = objective_id
    super()
  end

  def execute(position:, title:, xp_reward:, goal:, obstacle:, quick_fix:)
    return "Error: position must be between 1 and 5" unless (1..5).include?(position)

    objective = Objective.find(@objective_id)
    step = objective.steps.find_or_initialize_by(position: position)
    step.update!(title:, xp_reward:, goal:, obstacle:, quick_fix:, done: step.done || false)

    Turbo::StreamsChannel.broadcast_replace_to(
      objective,
      target: "spiral-section",
      partial: "objectives/spiral",
      locals: { objective: objective, steps: objective.steps.sorted }
    )

    "Step #{position} '#{title}' created (#{xp_reward} XP)"
  end
end
