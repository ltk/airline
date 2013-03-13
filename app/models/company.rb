class Company < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, :use => :slugged

  attr_accessible :name, :slug

  has_many :users, :inverse_of => :company
  has_many :invitations, :dependent => :destroy
  has_many :images
  
  validates :name, :slug, :presence => true
end
