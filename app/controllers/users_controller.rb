class UsersController < ApplicationController
  before_filter :ensure_authenticated, :except => [:new, :create]
  before_filter :load_user, :only => [:edit, :update]

  def new
    @user = params[:code] ? User.new_from_invite_code(params[:code]) : User.new
  end

  def create
    @user = User.new params[:user]
    if @user.save
      self.current_user = @user
      redirect_to_company_stream({ :notice => "User created" })
    else
      flash.now[:error] = "There were errors in your submission"
      render "new"
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user], :as => :update)
      redirect_to edit_user_path, :notice => "Information updated"
    else
      redirect_to edit_user_path, :alert => "There were errors with your submission"
    end
  end

  private

  def load_user
    @user = current_user
  end
end
