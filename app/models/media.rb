require 'carrierwave/orm/datamapper'

class Media
  include DataMapper::Resource
  include DataMapper::Validate

  property :id, Serial
  property :name, String, :length => 0..255
  property :description, Text

  without_auto_validations do
    property :image, String
    mount_uploader :image, ImageUploader

    property :media, String
    mount_uploader :media, MediaUploader
  end

  has_tags_on :mediatag
end