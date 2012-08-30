class Photo
  include MongoMapper::Document
  plugin MongoMachete::Taggable

  key :title, String
  key :gallery, String

  key :gallery_slug, String

  key :file, MediaFile::Embeddable

  def self.galleries
    fields(:gallery).order(:_id.desc).distinct(:gallery).delete_if(&:nil?).sort
  end

  # hooks
  before_save :slugify
  before_destroy :killall
  private
  def killall
    self.file.destroy unless self.file.nil?
  end
  def slugify
    self.gallery_slug = self.gallery.to_slug unless self.gallery.nil?
  end
end
