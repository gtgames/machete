class Cfg
  attr_accessor :config, :cache

  def self.refresh!
    c = MongoMapper.database['configurations'].find({}).find_all.to_a.map do |c|
      return c["key"] => c["value"]
    end
    @config = @config.merge c
    @cache = Time.new
  end

  def [] key
    if Time.new - @cache > 1.hour
      self.refresh!
    end
    @config[key]
  end

  def roles
    t = self[:roles]
    return (t.nil?)? [:admin] : t
  end

  def acl role
    @config[role]
  end

  @config = JSON.parse(File.read(Padrino.root("config", "config.json")))['site']
  @cache = Time.new
  self.refresh!

end


