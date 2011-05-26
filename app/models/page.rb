class Page
  include MongoMapper::Document
  plugin MongoMapper::Plugins::ReferencedTree
  plugin MongoMachete::Taggable

  one :title, :class => Translated
  key :slug

  one :lead, :class => Translated
  one :text, :class => Translated

  key :meta_keyword
  key :meta_description
  key :browser_title

  key :tags,  Array
  key :menu, Boolean, default: false
  
  #validations
  validates_presence_of  :title, :lead, :text

  timestamps!
  referenced_tree
  attr_protected :parent

  scope :by_slug, lambda{ |slug| where(slug: slug) }
  scope :roots, where(depth: 1)
end
