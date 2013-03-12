class ImagesController < ApplicationController
  before_filter :ensure_authenticated

  def create
    image = current_user.build_image(params[:image])

    message = if image.save
      { :notice => "Image saved. Add another?" }
    else
      { :alert => "There were errors with your submission" }
    end

    redirect_to referral_path, message
  end
end
