class PasswordResetMailer < ActionMailer::Base
  def send_reset_instructions(user)
    @user = user
    subject = "Password Reset Instructions"
    recipient = user.email
    mail(:to => recipient, :subject => subject)
  end
end