require 'carrierwave/orm/datamapper'
class Photo
  include DataMapper::Resource

  # property <name>, <type>
  property :id, Serial
  property :title, String

  without_auto_validations do
    property :photo, String
    mount_uploader :photo, ImageUploader
  end

  has_tags_on :tags
end