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

  scope :roots, where(depth: 1)
  def self.by_slug sl
    l = (Cfg[:locales].include? I18n.locale)? I18m.locale : Cfg[:locales].first
    return first(:"slug.#{l}" => "#{sl}".downcase)
  end
end
