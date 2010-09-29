require 'carrierwave/orm/datamapper'
class Upload
  include DataMapper::Resource

  property :id, Serial
  property :file, Text
  property :created_at, DateTime
  mount_uploader :file, Uploader

end
