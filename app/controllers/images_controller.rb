class ImagesController < ApplicationController
  helper_method :current_company
  before_filter :ensure_authenticated
  before_filter :ensure_authorized_for_company_stream, :only => :index
  before_filter :ensure_authorized_for_user_stream, :only => :index

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
    @images = stream_source.images.newest.page(params[:page])
  end

  private

  def requested_user
    @user ||= current_company.users.find_by_slug(params[:user_slug])
  end

  def ensure_authorized_for_company_stream
    if params[:company_slug] != current_company.slug
      redirect_to_company_stream
    end
  end

  def ensure_authorized_for_user_stream
    if params[:user_slug].present? && !current_user.coworker_of?(requested_user)
      redirect_to_company_stream
    end
  end

  def stream_source
    requested_user || current_company
  end
end
