class Company < ActiveRecord::Base
  attr_accessible :name

  has_many :users
  has_many :invitations, :dependent => :destroy
  has_many :images
  
  validates :name, :presence => true

  before_create :set_bayeux_token

  private

  def set_bayeux_token
    self.bayeux_token = SecureRandom.uuid
  end
end
