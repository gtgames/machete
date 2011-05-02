class Configuration
  include MongoMapper::Document

  key :key, String

  scope :by_key, lambda{ |k| where(:key => k) }
  def self.translable?
    where(:key => 'translable').count > 0
  end
end