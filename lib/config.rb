class Cfg
  attr_accessor :config, :cache

  def self.refresh!
    @config = MongoMapper.database['configurations'].find({}).find_all.to_a.map do |c|
      return c["key"] => c["value"]
    end
    puts @configx
    @cache = Time.new
  end

  def self.[] key
    if Time.new - @cache > 1.hour
      refresh!
    end
    @config.select{|x| x["key"] == key.to_s}.first[:value]
  end

  def self.translations
    t = self[:translations]
    return (t.nil?)? ['it'] : t
  end

  def self.roles
    t = self[:roles]
    return (t.nil?)? [:admin] : t
  end

  def self.acl role
    @config[role]
  end
end

Cfg.refresh!
