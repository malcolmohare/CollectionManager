class AdminController < ApplicationController
  before_action :verify_admin

  def index
    # Add any data you want to display on the admin page
    @users = User.all
  end

  private

  def verify_admin
    unless current_user&.admin?
      redirect_to root_path, alert: "You are not authorized to view this page."
    end
  end
end
