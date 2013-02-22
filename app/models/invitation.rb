class Invitation < ActiveRecord::Base
  attr_accessible :email, :company_id

  belongs_to :company

  validates :email, :presence => true, :email => true
end
