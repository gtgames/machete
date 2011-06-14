module Cfg

  class Backend
    attr_accessor :config, :cache

    def initialize
      @cache = Time.new
      @config = JSON.parse(File.read(Padrino.root("config", "config.json")))['site']
      fetch
    end

    def get key
      if Time.new - @cache > 1.hour
        refresh
      end
      @config[key.to_s]
    end

    def refresh
      fetch
    end

    protected
    def fetch
      conf = Hash.new
      MongoMapper.database['configurations'].find({}).find_all.to_a.each do |c|
        conf[c["key"]] = c["value"]
      end
      @config = @config.merge conf
      @cache = Time.new
    end
  end

  class << self
    def config
      Thread.current[:cfg_fetcher] ||= Cfg::Backend.new
    end
    def config= v
      Thread.current[:cfg_fetcher] = v
    end
    def roles
      t = self[:roles]
      return (t.nil?)? [:admin] : t
    end
    def [] key
      self.config.get key
    end
    def acl role
      self[role]
    end
    def refresh!
      self.config.refresh
    end
    def locale
      (self[:locales].include? I18n.locale)? I18n.locale : self[:locales].first
    end
    def default_locale
      Cfg[:locales].first
    end
  end
end

Cfg.refresh!


