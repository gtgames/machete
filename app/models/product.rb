require 'carrierwave/orm/datamapper'

class Product
  include DataMapper::Resource
  include DataMapper::Validate

  property :id, Serial
  is :localizable do
    property :name, String, :length => 0..255
    property :description, Text
  end
  property :discount, Integer, :default => 0, :min => 0, :max => 99
  property :price, Decimal, :default => 0, :min => 0

  without_auto_validations do
    property :image, String
    mount_uploader :image, ImageUploader
  end

  property :category_id, Integer


  belongs_to :category
end