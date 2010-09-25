class Order
  include DataMapper::Resource
  include DataMapper::Validate

  # property <name>, <type>
  property :id, Serial
  property :name, String, :length => 0..255
  

  has n, :items
end
