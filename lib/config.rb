class Cfg
  attr_accessor :config, :cache

  def self.refresh!
    @config = MongoMapper.database['configurations'].find({}).find_all.to_a
    @cache = Time.new
  end
  
  def self.[] key
    if Time.new - @cache > 1.hour
      refresh!
    end
    @config.select{|x| x["key"] == key.to_s}.first
  end

  def self.translations
    t = self[:translations]
    return (t.nil?)? ['it'] : t.split(' ')
  end
end

Cfg.refresh!
