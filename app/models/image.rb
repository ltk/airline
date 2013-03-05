class Image < ActiveRecord::Base
  attr_accessible :file

  validates :user_id, :file, :presence => true

  belongs_to :user
  belongs_to :company

  mount_uploader :file, ImageFileUploader

  delegate :avatar?, :avatar_url, :full_name, :to => :user, :prefix => true

  scope :newest_first, lambda { order("images.created_at DESC") }
end
