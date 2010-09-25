class Product
  include DataMapper::Resource
  include DataMapper::Validate
  include Paperclip::Resource

  property :id, Serial
  is :localizable do
    property :name, String, :length => 0..255
    property :description, Text, :length => 0..255
  end
  property :discount, Integer, :default => 0, :min => 0, :max => 99
  property :price, Decimal, :default => 0, :min => 0
  has_attached_file :image,
    :styles => {:original => '650:650>', :thumb => "256x256>" },
    :path => "public/images/products/:id/:style_:basename.:extension",
    :url => "/images/products/:id/:style_:basename.:extension",
    :convert_options => { :all => "-strip" }

  property :category_id, Integer

  belongs_to :category
end