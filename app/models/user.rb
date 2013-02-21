class User < ActiveRecord::Base
  include SimplestAuth::Model

  attr_accessible :first_name, :last_name, :company_name, :email, :password, :password_confirmation

  authenticate_by :email

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :company_name, :presence => true
  validates :email, :presence => true, :uniqueness => true, :email => true
  validates :password, :confirmation => true
  validates :password, :length => {:minimum => 5}, :if => :password_required?
  validates :password, :presence => true, :on => :create
  validates :password_confirmation, :presence => true, :on => :create
end
