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

  key :taxonomy, Translation

  #validations
  validates_presence_of  :title, :lead, :text

  # additional methods
  timestamps!

  def self.by_taxon sl
    return first(:"taxonomy.#{Cfg.locale}".in => %r{#{sl.downcase}})
  end

  #TODO: before_save :build_taxonomy
  protected
  def build_taxonomy
    slug = {}
    self['title'].each_pair{|k,v| slug << {k => v} }
    self['slug'] = slug
 end
end
