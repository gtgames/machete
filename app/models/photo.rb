require 'carrierwave/orm/sequel'
class Photo < Sequel::Model
  def_dataset_method :full_text_search
  mount_uploader :photo, ImageUploader
end
