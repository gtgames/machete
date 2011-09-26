class Hotel
  include MongoMapper::Document
  plugin MongoMachete::Taggable 

  key :title, String
  key :slug, String

  key :description, String

  key :address, String

  key :photo, MediaFile::Embeddable

  key :lat, Float
  key :lng, Float

  def map size='200x200'
    "http://maps.googleapis.com/maps/api/staticmap?center=#{ self[:lat] },#{ self[:lng] }&zoom=11&size=#{ size }&sensor=false"
  end
  
  before_save :slugify
  protected
  def slugify
    self[:slug] = self[:title].to_slug
  end
end