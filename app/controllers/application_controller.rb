class ApplicationController < ActionController::Base
  include SimplestAuth::Controller
  protect_from_forgery

  def ensure_authenticated
    unless logged_in?
      redirect_to root_path, :alert => "Please sign in."
    end
  end

  def current_company
    @company ||= current_user.company
  end

  def redirect_to_company_stream(options = {})
    redirect_to company_images_path(:company_slug => current_company.slug), options
  end

  def referral_path
    URI(request.referer).path
  end
end
