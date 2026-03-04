class ObjectivesController < ApplicationController
  before_action :set_objective, only: [:show] # :edit, :update, :destroy, :confirm

  def index
    @objectives = current_user.objectives
    # A modifier later
  end

  def show
    @chat = @objective.chat

    @message = @chat.messages.new if @chat
  end

  # def new
  #   @objective = Objective.new
  # end

  # def create
  #   @objective = current_user.objectives.build(objective_params)
  #   if @objective.save
  #     redirect_to objective_path(@objective), notice: "Objective created."
  #   else
  #     render :new, status: :unprocessable_entity
  #   end
  # end

  # def edit
  # end

  # def update
  #   if @objective.update(objective_params)
  #     redirect_to objective_path(@objective), notice: "Objective updated."
  #   else
  #     render :edit, status: :unprocessable_entity
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
  #   params.require(:objective).permit(:title, :description)
  # end
end
