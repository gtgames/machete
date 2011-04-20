class Page
  include MongoMapper::Document
  plugin MongoMapper::Plugins::ReferencedTree
  plugin MongoMachete::Taggable

  key :title, String
  key :slug,  String
  key :lead,  String
  key :text,  String
  key :tags,  Array

  timestamps!
  referenced_tree
  ensure_index :slug, :unique => true

  # validations
  validates_presence_of     :title, :lead
  validates_uniqueness_of   :slug, :title

  scope :by_slug, lambda{ |slug| where(slug: slug) }
  scope :roots, where(depth: 1)

  before_validation :slugify
  private
  def slugify
    self['slug'] = self['title'].to_slug
  end
end
