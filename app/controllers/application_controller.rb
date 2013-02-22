class ApplicationController < ActionController::Base
  include SimplestAuth::Controller
  protect_from_forgery

  def ensure_authenticated
    unless logged_in?
      redirect_to new_session_path, :alert => "You must sign in first"
    end
  end
end
