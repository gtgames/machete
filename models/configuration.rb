class Configuration
  include MongoMapper::Document
  key :_id, String, :default => lambda { String.new }
  key :val

  before_save :parse_json
  after_save :reloader
  private
  def parse_json
    self.val = JSON.parse(self.val)
  end
  def reloader
    Cfg.refresh!
  end
end
