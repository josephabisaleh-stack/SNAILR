class ObjectivesController < ApplicationController
  before_action :set_objective, only: %i[show confirm] # edit update destroy

  def index
    @objectives = current_user.objectives.order(created_at: :desc)
    # ne pas afficher ceux in_creation
  end

  def show
    @chat = @objective.chat

    @message = @chat.messages.new if @chat
  end

  # def edit
  # end

  def confirm
    @objective.in_progress!
    redirect_to objective_path(@objective), notice: "Objective confirmed!"
  end

  # def update
  #   if @objective.update(objective_params)
  #     redirect_to objective_path(@objective), notice: "Objective updated."
  #   else
  #     render :edit, status: :unprocessable_content
  #   end
  # end

  # def destroy
  #   @objective.destroy
  #   redirect_to objectives_path, notice: "Objective deleted."
  # end

  private

  def set_objective
    @objective = current_user.objectives.find(params[:id])
  end

  # def objective_params
  #   params.expect(objective: %i[title description])
  # end
end
