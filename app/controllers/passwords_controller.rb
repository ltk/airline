class PasswordsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(password_params[:email])
    if user
      user.send_reset_instructions
      redirect_to root_path, :notice => "A password reset email has been sent."
    else
      redirect_to new_password_path, :alert => "We couldn't find a user with that email address."
    end
  end

  private

  def password_params
    params[:password] || {}
  end
end
