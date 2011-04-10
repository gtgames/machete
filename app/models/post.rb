class Post
  include MongoODM::Document
  self.include_root_in_json = false

  field :title, String
  field :text,  String
  field :photo, SimpleUploader

  index :slug, :unique => true
  
  before_save :generate_slug

  protected
  def generate_slug
    self[:slug] = title.to_slug
  end
  
end
