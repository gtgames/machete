require 'carrierwave/orm/datamapper'

class Product
  include DataMapper::Resource
  include DataMapper::Validate

  property :id, Serial
  is :localizable do
    property :name, String, :length => 0..255
    property :description, Text
  end

  property :discount, Integer, :default => 0, :min => 0
  property :price, Integer, :default => 0, :min => 0

  property :quantity, Integer, :min => 0

  property :link_ebay, String, :length => 0..255

  without_auto_validations do
    property :image, String
    mount_uploader :image, ImageUploader
  end

  def price
    (attribute_get(:price)/100).to_s
  end
  def price=(p)
    attribute_set(:price, p.gsub(/[\.,]/, ''))
  end

  def discount
    (attribute_get(:discount)/100).to_s
  end
  def discount=(p)
    attribute_set(:discount, p.gsub(/[\.,]/, ''))
  end

  def self.discounted
    all :dicount.gt => 0
  end

  property :category_id, Integer
  belongs_to :category
end