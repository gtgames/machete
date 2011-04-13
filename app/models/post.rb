class Post
  include MongoMapper::Document
  plugin MongoMachete::Plugin::Taggable

  key :title, String
  key :slug,  String
  key :text,  String
  key :photo, SimpleUploader
  key :tags,  Array

  ensure_index :slug, :unique => true
  scope :by_slug, lambda { |slug| where(:slug => slug) }

  before_save :generate_slug
  protected
  def generate_slug
    self[:slug] = title.to_slug
  end
end
