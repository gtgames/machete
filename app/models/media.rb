require 'carrierwave/orm/sequel'
class Media < Sequel::Model
  many_to_many :tags, :join_table => :media_taggins
  plugin :taggable

  def_dataset_method :full_text_search
  mount_uploader :file, MediaUploader
end
