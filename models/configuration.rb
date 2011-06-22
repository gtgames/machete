class Configuration
  include MongoMapper::Document
  key :_id, String, :default => lambda { String.new }
  key :val
  def val=(v)
    super( (v.is_a? String)? JSON.parse(v) : v )
  end

  #before_save :parse_json
  after_save :update_cfg
  private
  def parse_json
    self.val = JSON.parse(self.val) if self.val.is_a? String
  end
  def update_cfg
    Cfg[self._id]= self.val
  end
end
