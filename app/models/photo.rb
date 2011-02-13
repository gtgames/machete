require 'carrierwave/orm/sequel'
class Photo < Sequel::Model
  plugin :taggable
  
  def_dataset_method :full_text_search
  mount_uploader :file, ImageUploader
end
