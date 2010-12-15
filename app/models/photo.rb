require 'carrierwave/orm/sequel'
class Photo < Sequel::Model
  many_to_many :tags, :join_table => :photo_taggins
  
  def_dataset_method :full_text_search
  mount_uploader :photo, ImageUploader
end
