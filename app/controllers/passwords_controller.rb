class PasswordsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(user_params[:email])
    if user
      user.send_password_reset_instructions
      redirect_to root_path, :notice => "A password reset email has been sent."
    else
      redirect_to new_password_path, :alert => "We couldn't find a user with that email address."
    end
  end

  def edit
    @user = User.find_by_password_reset_token(params[:token]) if params[:token].present?
    if @user
      self.current_user = @user
    else
      redirect_to new_password_path, :alert => "Invalid reset token"
    end
  end

  private

  def user_params
    params[:user] || {}
  end
end
