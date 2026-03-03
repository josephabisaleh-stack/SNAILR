class StepsController < ApplicationController
  # before_action :set_objective
  # before_action :set_step, only: [:show, :update, :destroy, :toggle]

  # def show
  # end

  # def create
  #   @step = @objective.steps.build(step_params)
  #   if @step.save
  #     redirect_to objective_path(@objective), notice: "Step added."
  #   else
  #     redirect_to objective_path(@objective), alert: "Could not add step."
  #   end
  # end

  # def update
  #   if @step.update(step_params)
  #     redirect_to objective_path(@objective), notice: "Step updated."
  #   else
  #     redirect_to objective_path(@objective), alert: "Could not update step."
  #   end
  # end

  # def destroy
  #   @step.destroy
  #   redirect_to objective_path(@objective), notice: "Step deleted."
  # end

  # # def mark_step_as_done

  # # end

  # private

  # def set_objective
  #   @objective = current_user.objectives.find(params[:objective_id])
  # end

  # def set_step
  #   @step = @objective.steps.find(params[:id])
  # end

  # def step_params
  #   params.require(:step).permit(:title, :position, :xp_reward)
  # end
end
