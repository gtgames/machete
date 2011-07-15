class Post
  include MongoMapper::Document
  plugin MongoMachete::Taggable

  key :title, String
  key :slug,  String
  key :lead,  String
  key :text,  String
  key :photo, MediaFile::Embeddable
  key :tags,  Array

  timestamps!

  scope :by_slug, lambda { |slug| where(:slug => slug) }

  validates_presence_of     :title, :lead, :text
  validates_uniqueness_of   :title

  before_save :slugify

  private
  def slugify
    self.slug = self.title.to_slug
  end
end
