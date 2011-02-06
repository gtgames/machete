require 'carrierwave/processing/mini_magick'
class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  MiniMagick.processor = :gm

  storage :file

  def root; File.join(Padrino.root,"public/"); end

  def store_dir
    "assets/#{model.class.to_s.underscore}/#{model.id}"
  end

  def cache_dir
    Padrino.root("tmp")
  end

  def default_url
    "/images/default_image.png"
  end

  process :resize_to_fit => [740, 580]
  version :thumb do
    process :resize_to_fill => [100, 100]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end