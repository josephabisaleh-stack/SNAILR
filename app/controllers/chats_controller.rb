class ChatsController < ApplicationController
  def create
    @objective = Objective.create!(user: current_user)

    @chat = Chat.new
    @chat.objective = @objective
    @chat.user = current_user

    if @chat.save
      redirect_to objective_path(@objective)
    else
      redirect_to objectives_path, alert: "Cannot start."
    end
  end
end
