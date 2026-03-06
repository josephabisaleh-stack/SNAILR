class StepsController < ApplicationController
  def mark_step_as_done
    @step = Step.find(params[:id])
    objective = @step.objective

    return head :forbidden unless objective.user == current_user

    @step.update!(done: true)

    total_xp = objective.steps.sum(:xp_reward)
    done_xp = objective.steps.done.sum(:xp_reward)
    new_progress = total_xp.positive? ? (done_xp * 100.0 / total_xp).round : 0
    objective.update!(progress: new_progress)

    done_count = objective.steps.done.count
    total_count = objective.steps.count

    render json: { done_count: done_count, total_count: total_count, progress: new_progress }
  end
end
