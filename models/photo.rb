class Photo
  include MongoMapper::Document
  plugin MongoMachete::Taggable

  key :title, String
  key :gallery, String

  key :gallery_slug, String

  key :file, MediaFile::Embeddable

  def self.galleries
    fields(:gallery).distinct(:gallery).delete_if(&:nil?)
  end

  # hooks
  before_save :slugify
  before_destroy :killall
  private
  def killall
    file.destroy
  end
  def slugify
    self.gallery_slug = self.gallery.to_slug
  end
end
