class AttachmentUploader < CarrierWave::Uploader::Base
  # include CarrierWave::MiniMagick

  storage :file

  def root; File.join(Padrino.root,"public/"); end

  def store_dir
    "uploads/#{model.id}"
  end

  def cache_dir
    Padrino.root("tmp")
  end

  def extension_white_list
    %w(pdf zip jpg jpeg gif png)
  end
end
