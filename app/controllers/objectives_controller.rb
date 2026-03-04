class ObjectivesController < ApplicationController
  before_action :set_objective, only: %i[show edit update destroy]

  def index
    @objectives = current_user.objectives.order(created_at: :desc)
  end

  def show
    @chat = @objective.chat
    @message = @chat.messages.new
  end

  def new
    @objective = Objective.new
  end

  def create
    @objective = current_user.objectives.build(objective_params)
    if @objective.save
      redirect_to objective_path(@objective), notice: "Objective created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @objective.update(objective_params)
      redirect_to objective_path(@objective), notice: "Objective updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @objective.destroy
    redirect_to objectives_path, notice: "Objective deleted."
  end

  private

  def set_objective
    @objective = current_user.objectives.find(params[:id])
  end

  def objective_params
    params.expect(objective: %i[title description])
  end
end
