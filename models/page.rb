class Page
  include MongoMapper::Document
  plugin MongoMapper::Plugins::HashParameterAttributes

  key :title, Translation
  key :slug, Translation

  key :lead, Translation
  key :text, Translation

  key :meta_keyword
  key :meta_description
  key :browser_title

  key :position, Integer, :default => 0

  many :taxonomy, :class_name => 'Taxonomy::Embeddable'

  #validations
  validates_presence_of  :title, :lead, :text

  # additional methods
  timestamps!

  # Scopes
  def self.by_slug sl
    return where(:"slug.#{Cfg.locale}" => %r{#{sl}}).first
  end
  def self.by_taxonomy sl
    return where(:"taxonomy.path.#{Cfg.locale}" => %r{#{sl.downcase}})
  end
  
  # Setters
  def slug= text
    self['slug'] = text.to_slug
  end
end
