class ObjectivesController < ApplicationController
  before_action :set_objective, only: %i[show destroy]

  def new
  end

  def index
    @objectives = current_user.objectives.order(created_at: :desc).includes(chat: :messages)
    @youtube_links = build_youtube_links(@objectives)
  end

  def show
    @chat = @objective.chat
    @steps = @objective.steps.sorted
  end

  # def edit
  # end

  # def update
  #   if @objective.update(objective_params)
  #     redirect_to objective_path(@objective), notice: "Objective updated."
  #   else
  #     render :edit, status: :unprocessable_content
  #   end
  # end

  def destroy
    @objective.destroy
    redirect_to objectives_path
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

      urls = last_msg.content.scan(%r{https?://(?:www\.)?youtube\.com/watch\?v=[\w-]+})
      hash[objective.id] = urls if urls.any?
    end
  end

  # def objective_params
  #   params.expect(objective: %i[title description])
  # end
end
