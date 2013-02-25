class Invitation < ActiveRecord::Base
  attr_accessible :email, :company_id

  belongs_to :company

  validates :email, :presence => true, :email => true

  before_create :set_invite_code
  after_create :send_invite_email

  private

  def set_invite_code
    self.code ||= generate_code
  end

  def generate_code
    Digest::SHA1.hexdigest("--#{Time.now.utc.to_s}--#{self.email}--")
  end

  def send_invite_email
    mail = InvitationMailer.invite(self).deliver
  end
end
