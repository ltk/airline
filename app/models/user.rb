class User < ActiveRecord::Base
  include SimplestAuth::Model

  attr_accessible :first_name, :last_name, :email, :company_id, :password, :password_confirmation, :company_attributes

  belongs_to :company

  accepts_nested_attributes_for :company, :reject_if => :all_blank

  authenticate_by :email

  validates :first_name, :last_name, :presence => true
  validates :email, :presence => true, :uniqueness => true, :email => true
  validates :password, :confirmation => true
  validates :password, :length => {:minimum => 5}, :if => :password_required?
  validates :password, :presence => true, :on => :create
  validates :password_confirmation, :presence => true, :on => :create

  def self.new_from_invite_code(code)
    invite = Invitation.find_by_code(code)
    if invite
      self.new(:email => invite.email, :company_id => invite.company_id)
    else
      self.new
    end
  end
end