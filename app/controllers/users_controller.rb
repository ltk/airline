class UsersController < ApplicationController
  def new
    @user = params[:code] ? User.new_from_invite_code(params[:code]) : User.new
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

  def edit
    @user = User.find_by_id(params[:id])
    allow_self_service_only
  end

  def update
    @user = User.find_by_id(params[:id])
    allow_self_service_only

    @user.update_attributes(params[:user], as: :update)
    if @user.save
      redirect_to edit_user_path(@user.id), :notice => "Information updated"
    else
      redirect_to edit_user_path(@user.id), :alert => "There were errors with your submission"
    end
  end

  private

  def allow_self_service_only
    if @user != current_user
      redirect_to root_path, :alert => "You don't have permission to edit that user account"
    end
  end
end
