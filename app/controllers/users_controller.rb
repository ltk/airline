class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if(@user.save)
      self.current_user = @user
      flash[:notice] = "User created"
      redirect_to root_path
    else
      flash[:error] = "There were errors in your submission"
      render "new"
    end
  end
end
