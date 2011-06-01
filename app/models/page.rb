class Page
  include MongoMapper::Document
  plugin MongoMapper::Plugins::ReferencedTree
  plugin MongoMachete::Taggable

  one :title, :class => Translated
  one :slug, :class => Translated

  one :lead, :class => Translated
  one :text, :class => Translated

  key :meta_keyword
  key :meta_description
  key :browser_title

  key :tags,  Array
  key :menu, Boolean, default: false

  key :position, Integer, default: 0

  #validations
  validates_presence_of  :title, :lead, :text

  timestamps!
  referenced_tree
  attr_protected :parent

  scope :by_slug, lambda{ |slug|
    l = (Cfg[:locales].include? I18n.locale)? I18m.locale : Cfg[:locales].first
    first(:"slug.#{l}" => "#{slug}".downcase)
  }
  scope :roots, where(depth: 1)
end
