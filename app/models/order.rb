class Order
  include DataMapper::Resource
  include DataMapper::Validate

  property :id, Serial
  property :name, String, :length => 0..255

  has n, :items
end
