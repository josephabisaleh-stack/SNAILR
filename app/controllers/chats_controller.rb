class ChatsController < ApplicationController
  def create
    @objective = Objective.create!(user: current_user)
    @chat = Chat.create!(objective: @objective, user: current_user)

    message = Message.create!(chat: @chat, role: "user", content: params[:content])
    LlmResponseJob.perform_later(@chat.id, message.id)

    redirect_to objective_path(@objective)
  end
end
