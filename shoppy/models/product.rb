class Product
  include DataMapper::Resource
  include DataMapper::Validate
  include Paperclip::Resource

  # property <name>, <type>
  property :id, Serial
  property :name, String, :lenght => 0..255
  property :price, Decimal, :default => 0.00, :min => 0.00

  has_tags_on :shop
  
  has n, :product_photos
end
