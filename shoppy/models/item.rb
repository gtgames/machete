class Item
  include DataMapper::Resource
  include DataMapper::Validate

  property :id, Serial
  property :name, String, :lenght => 0..255
  property :quantity, Integer

  belongs_to :order
end
