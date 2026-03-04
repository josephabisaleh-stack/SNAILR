class MessagesController < ApplicationController
  SYSTEM_PROMPT = "You are an elite Performance Coach specializing in behavioral science. Your goal is to transform my broad long-term objectives into a high-precision execution plan.

Your Constraints:

Deconstruct: Break each goal into daily or weekly micro-steps.
Metric-Driven: Every step must have a clear definition of success (e.g., 'Do this for 20 mins' rather than 'Work on this').
Friction Check: Briefly identify one potential obstacle for each step and a 'quick-fix' strategy.
Format: Use bolded headers for phases and bullet points for actions. Be concise and authoritative."

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @objective = @chat.objective

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)
      Message.create(role: "assistant", content: response.content, chat: @chat)

      redirect_to objective_path(@objective)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
