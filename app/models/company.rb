class Company < ActiveRecord::Base
  attr_accessible :name

  has_many :users
  has_many :invitations, :dependent => :destroy
  has_many :images
  
  validates :name, :presence => true
end
