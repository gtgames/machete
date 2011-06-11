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

  key :taxonomy, Taxonomy::Embeddable

  #validations
  validates_presence_of  :title, :lead, :text, :taxonomy

  # additional methods
  timestamps!

  # Scopes
  def self.by_taxon sl
    return first(:"taxonomy.path.#{Cfg.locale}".in => %r{#{sl.downcase}})
  end
end
