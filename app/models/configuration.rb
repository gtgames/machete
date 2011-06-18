class Configuration
  include MongoMapper::Document

  after_save :reloader
  private
  def reloader
    Cfg.refresh!
  end
end
