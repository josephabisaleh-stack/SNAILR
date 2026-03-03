class ChatsController < ApplicationController
  def create
    @objective = current_user.objectives.find(params[:objective_id])
    @chat = @objective.chats.build(user: current_user)
    if @chat.save
      redirect_to chat_path(@chat)
    else
      redirect_to objective_path(@objective), alert: "Could not start chat."
    end
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:id])
  end
end
