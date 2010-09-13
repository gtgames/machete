class Product
  include DataMapper::Resource
  include DataMapper::Validate
  include Paperclip::Resource
  
  property :title, String, :lenght => 0..255
  has_attached_file :image,
    :styles => {:original => '650:650>', :thumb => "256x256>" },
    :path => "public/images/products/:id/:style_:basename.:extension",
    :url => "/images/products/:id/:style_:basename.:extension",
    :convert_options => { :all => "-strip" }

    belongs_to :product
end