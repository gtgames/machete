class Category
  include DataMapper::Resource
  include DataMapper::Validate

  property :id, Serial
  is :localizable do
    property :name, String, :length => 0..255
    property :description, Text
  end

  has n, :products
end
