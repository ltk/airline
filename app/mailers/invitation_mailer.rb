class InvitationMailer < ActionMailer::Base
  def invite(invitation)
    @invitation = invitation
    mail :from => 'email@airlineapp.com',
         :to => invitation.email,
         :subject => 'Invitation to Airline'
  end
end