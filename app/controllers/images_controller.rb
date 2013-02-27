class ImagesController < ApplicationController
  before_filter :ensure_authenticated

  def new
  end

  def create
    image = Image.new(params[:image])
    image.user = current_user
    image.company = current_user.company if current_user.company

    if image.save
      redirect_to new_image_path, :notice => "Image saved. Add another?"
    else
      redirect_to new_image_path, :alert => "There were errors with your submission"
    end
  end
end
