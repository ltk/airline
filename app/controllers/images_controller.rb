class ImagesController < ApplicationController
  before_filter :ensure_authenticated
  before_filter :load_company, :only => :index
  before_filter :ensure_authorized_for_company, :only => :index

  def create
    image = current_user.build_image(params[:image])

    message = if image.save
      { :notice => "Image saved. Add another?" }
    else
      { :alert => "There were errors with your submission" }
    end

    redirect_to referral_path, message
  end

  def index
    if user_stream_request?
      @user = @company.users.find_by_slug(params[:user_slug])
      redirect_to_company_stream unless current_user.coworker_of?(@user)
    end

    @images = stream_source.images.newest.page(params[:page])
  end

  private

  def load_company
    @company = Company.find_by_slug(params[:company_slug])
  end

  def ensure_authorized_for_company
    unless current_user.authorized_for_company?(@company)
      redirect_to_company_stream
    end
  end

  def redirect_to_company_stream
    redirect_to company_images_path(:company_slug => current_user.company_slug)
  end

  def user_stream_request?
    params[:user_slug].present?
  end

  def stream_source
    user_stream_request? ? @user : @company
  end

  def referral_path
    URI(request.referer).path
  end
end
