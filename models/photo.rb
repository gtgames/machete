class Photo
  include MongoMapper::Document
  plugin MongoMachete::Taggable

  key :title, String
  key :gallery, String

  key :file, MediaFile::Embeddable

  def self.galleries
    fields(:gallery).distinct(:gallery)
  end

  # hooks
  before_destroy :killall
  private
  def killall
    file.destroy
  end
end
