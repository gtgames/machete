class Photo
  include DataMapper::Resource
  include DataMapper::Validate
  include Paperclip::Resource

  # property <name>, <type>
  property :id, Serial
  property :title, String
  has_attached_file :photo,
    :styles => {:original => '1150:1150>', :thumb => "150x150>" },
    :path => "public/photos/:id/:style_:basename.:extension",
    :url => "/photos/:id/:style_:basename.:extension",
    :convert_options => { :all => "-strip" }

  has_tags_on :tags
end
