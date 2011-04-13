class Configuration
  include MongoMapper::Document

  key :key, String
  ensure_index :key, :unique => true

  # :value can be anything Array/Hash/String/Regex
  def value=v
    self['value']= v
  end
  def value
    ['value']
  end
  ##

  scope :by_key, lambda{ |k| where(:key => k) }
  def self.translable?
    where(:key => 'translable').count > 0
  end
end
