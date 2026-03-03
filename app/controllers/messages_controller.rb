class MessagesController < ApplicationController
  def create
    @chat = current_user.chats.find(params[:chat_id])
    @message = @chat.messages.build(message_params)
    @message.role = :user
    if @message.save
      redirect_to chat_path(@chat)
    else
      redirect_to chat_path(@chat), alert: "Could not send message."
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
