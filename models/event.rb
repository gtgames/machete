class Event
  include MongoMapper::Document

  key :title, String
  key :slug, String

  key :description, String

  key :from, Time, :default => lambda { Time.now.xmlschema }
  key :to, Time, :default => lambda { Time.now.xmlschema }

  def from
    (self[:from].is_a? String)? self[:from] : self[:from].xmlschema
  end
  def to
    (self[:to].is_a? String)? self[:to] : self[:to].xmlschema
  end

  key :file, MediaFile::Embeddable
  
  before_save :slugify
  protected
  def slugify
    self[:slug] = self[:title].to_slug
  end
end
