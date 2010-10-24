require 'carrierwave/orm/sequel'
class Photo < Sequel::Model
  mount_uploader :photo, ImageUploader
end
