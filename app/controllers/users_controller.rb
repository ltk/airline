class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new params[:user]
    if @user.save
      self.current_user = @user
      redirect_to root_path, :notice => "User created"
    else
      flash.now[:error] = "There were errors in your submission"
      render "new"
    end
  end
end
