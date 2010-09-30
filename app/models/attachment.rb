require 'carrierwave/orm/datamapper'
class Attachment
  include DataMapper::Resource

  property :id, Serial
  property :file, Text
  property :created_at, DateTime

  mount_uploader :file, AttachmentUploader

end
