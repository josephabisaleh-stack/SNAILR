class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    redirect_to new_objective_path if user_signed_in?
  end

  def settings
  end
end
