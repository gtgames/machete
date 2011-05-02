class Post
  include MongoMapper::Document
  plugin MongoMachete::Taggable

  key :title, String
  key :slug,  String
  key :text,  String
  key :photo, SimpleUploader
  key :tags,  Array

  timestamps!

  scope :by_slug, lambda { |slug| where(:slug => slug) }

  validates_presence_of     :title, :lead, :text
  validates_uniqueness_of   :slug, :title

  before_save :generate_slug
  protected
  def generate_slug
    self[:slug] = title.to_slug
  end
end
