class InvitationsController < ApplicationController
  before_filter :ensure_authenticated

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new params[:invitation]
    @invitation.company_id = current_user.company_id
    if @invitation.save
      redirect_to root_path, :notice => "Invitation sent"
    else
      flash.now[:error] = "There were errors in your submission"
      render "new"
    end
  end
end
