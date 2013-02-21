class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      self.current_user = user
      redirect_to root_path, :alert => "Signed in successfully"
    else
      flash[:error] = "Couldn't locate a user with those credentials"
      render "new"
    end
  end

  def destroy
    self.current_user = nil
    redirect_to new_session_path
  end
end
