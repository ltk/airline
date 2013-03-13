class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(session_params[:email], session_params[:password])
    if user
      self.current_user = user
      redirect_to_images
    else
      redirect_to new_session_path, :alert => "Couldn't locate a user with those credentials"
    end
  end

  def destroy
    self.current_user = nil
    redirect_to root_path, :alert => "Signed out"
  end

  private

  def redirect_to_images
    redirect_to_company_stream({ :alert => "Signed in successfully" })
  end

  def session_params
    params[:session] || {}
  end
end
