class PartnerUploader < CarrierWave::Uploader::Base
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

  process :resize_to_fit => [100, 100]
  def extension_white_list
    %w(jpg jpeg gif png)
  end
end