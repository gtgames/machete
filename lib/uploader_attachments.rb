require 'carrierwave/processing/mini_magick'
class AttachmentUploader < CarrierWave::Uploader::Base
  storage :file

  def root; File.join(Padrino.root,"public/"); end

  def store_dir
    "assets/#{model.class.to_s.underscore}/#{model.id}"
  end

  def cache_dir
    Padrino.root("tmp")
  end

  def extension_white_list
    %w(pdf zip jpg jpeg gif png)
  end
end