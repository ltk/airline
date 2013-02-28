class Image < ActiveRecord::Base
  attr_accessible :company_id, :file, :user_id

  validates :user_id, :file, :presence => true

  belongs_to :user
  belongs_to :company

  mount_uploader :file, ImageFileUploader

  delegate :avatar?, :avatar_url, :full_name, :to => :user, :prefix => true
end
