class Hotel
  include MongoMapper::Document
  plugin MongoMachete::Taggable 

  key :title, String
  key :slug, String

  key :description, String

  key :address, String

  key :photo, MediaFile::Embeddable

  key :features, Array

  key :lat, String
  key :lng, String
  key :elevation, String

  def map
    "http://maps.googleapis.com/maps/api/staticmap?center=#{ self[:lat] },#{ self[:lng] }&markers=color:blue%7C#{ self[:lat] },#{ self[:lng] }&zoom=15&size=400x400&sensor=false"
  end
  
  before_save :slugify
  protected
  def slugify
    self[:slug] = self[:title].to_slug
  end
end