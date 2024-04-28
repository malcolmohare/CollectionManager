class BaseController < ApplicationController

  protected

  def redirect_if_not_logged_in
    unless user_signed_in?  # assuming you have a logged_in? method defined somewhere
      redirect_to new_user_session_url, alert: "You must be logged in to access this section"
    end
  end
end