class ImageFileUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :small do
    process :resize_to_fit => [250, 250]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
