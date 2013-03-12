class ApplicationController < ActionController::Base
  include SimplestAuth::Controller
  protect_from_forgery

  def ensure_authenticated
    unless logged_in?
      redirect_to root_path, :alert => "Please sign in."
    end
  end
end
