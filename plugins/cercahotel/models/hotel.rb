class Hotel
  include MongoMapper::Document
  plugin MongoMachete::Taggable

  # Geospatial Indexing
  ensure_index [['loc', Mongo::GEO2D]], {:unique => false, :background => true}

  key :title, String
  key :slug, String

  key :type, String

  key :description, String

  key :address, String

  key :email, String
  key :fax, String
  key :tel, String

  key :photo, MediaFile::Embeddable

  key :features, Array

  key :featured, Boolean, :default => false

  key :loc, Array

  key :elevation, String

  def map
    "http://maps.googleapis.com/maps/api/staticmap?center=#{ self[:loc][0] },#{ self[:loc][1] }&markers=color:blue%7C#{ self[:loc][0] },#{ self[:loc][1] }&zoom=15&size=400x400&sensor=false"
  end

  #! Finders
  def self.by_location(lat, long, opts={}, limit=10)
    q = { :loc => {'$near'  => [lat, long]} }.merge(opts)
    where(q).order(:featured.asc).limit(limit)
  end

  def loc=(v)
    self[:loc] = v.map(&:to_f)
  end

  before_save :slugify
  protected
  def slugify
    self[:slug] = self[:title].to_slug
  end
end
