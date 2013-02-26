class Invitation < ActiveRecord::Base
  attr_accessible :email, :company_id

  belongs_to :company

  validates :email, :presence => true, :email => true

  before_create :set_invite_code
  after_create :send_invite_email

  private

  def self.code_unique?(code)
    find_by_code(code).nil?
  end

  def set_invite_code
    begin
      self.code = generate_code
    end until self.class.code_unique?(self.code)
  end

  def generate_code
    SecureRandom.urlsafe_base64(12)
  end

  def send_invite_email
    InvitationMailer.invite(self).deliver
  end
end
