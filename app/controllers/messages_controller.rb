class MessagesController < ApplicationController
  def create
    @chat = current_user.chats.find(params[:chat_id])
    @objective = @chat.objective

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      LlmResponseJob.perform_later(@chat.id, @message.id)
      redirect_to objective_path(@objective)
    else
      render "objectives/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
