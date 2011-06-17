class Post
  include MongoMapper::Document
  plugin MongoMachete::Taggable

  key :title, String
  key :slug,  String
  key :lead,  String
  key :text,  String
  key :photo, SimpleUploader
  key :tags,  Array

  timestamps!

  scope :by_slug, lambda { |slug| where(:slug => slug) }

  validates_presence_of     :title, :slug, :lead, :text
  validates_uniqueness_of   :title, :slug
end
