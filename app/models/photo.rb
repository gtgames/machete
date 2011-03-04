require 'carrierwave/orm/sequel'
class Photo < Sequel::Model
  plugin :taggable
  
  def_dataset_method :full_text_search
  mount_uploader :file, ImageUploader
  
  def self.random(num = 1)
    with_sql("SELECT * FROM \"#{table_name}\" ORDER BY RANDOM() LIMIT #{num}").all
  end
end
