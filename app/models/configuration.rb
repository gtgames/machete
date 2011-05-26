class Configuration
  include MongoMapper::Document

  key :key, String

  after_save :reloader
  
  scope :by_key, lambda{ |k| where(:key => k) }
  def self.translable?
    where(:key => 'translable').count > 0
  end

  private
  def reloader
    Cfg.reload!
  end
end
