class ImagesController < ApplicationController
  before_filter :ensure_authenticated

  def create
    image = Image.new(params[:image])
    image.user = current_user
    image.company = current_user.company

    if image.save
      message = { :notice => "Image saved. Add another?" }
    else
      message = { :alert => "There were errors with your submission" }
    end

    redirect_to root_path, message
  end

  def index
    @images = current_user.image_source.images.newest_first.page(params[:page])
  end
end
