class Page
  include MongoMapper::Document
  plugin MongoMapper::Plugins::ReferencedTree
  plugin MongoMachete::Taggable

  key :title, String
  key :slug,  String
  key :lead,  String
  key :text,  String
  key :tags,  Array

  key :meta_keyword, String
  key :meta_description, String
  key :browser_title, String
  key :menu, Boolean, :default => false

  timestamps!
  referenced_tree
  attr_protected :parent

  # validations
  validates_presence_of     :title, :lead, :text
  validates_uniqueness_of   :slug, :title

  scope :by_slug, lambda{ |slug| where(slug: slug) }
  scope :roots, where(depth: 1)

  before_validation :slugify
  private
  def slugify
    self['slug'] = self['title'].to_slug
  end
end
