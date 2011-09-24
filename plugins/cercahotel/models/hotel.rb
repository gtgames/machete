class Hotel
  include MongoMapper::Document
  plugin MongoMachete::Taggable 

  key :title, String
  key :slug, String

  key :description, String

  key :place, String

  key :file, MediaFile::Embeddable

  before_save :slugify
  protected
  def slugify
    self[:slug] = self[:title].to_slug
  end
end