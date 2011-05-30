class Configuration
  include MongoMapper::Document

  key :key, String


  def value=(val)
    begin
      self[:value] = JSON.parse val
    rescue e
      self[:value] = nil
      logger.error e
    end
  end

  validates_presence_of :key
  
  after_save :reloader

  scope :by_key, lambda{ |k| where(:key => k) }
  private
  def reloader
    Cfg.reload!
  end
end
