class Translation < HashWithIndifferentAccess
  def self.from_mongo(value)
    Translation.new(value || {})
  end

  def available_locales
    symbolize_keys.keys
  end

  def to_s
    self[Cfg.locale] || self[Cfg.default_locale] || "..."
  end

  def in_current_locale=(value)
    self[Cfg.locale] = value
  end

  def << (value)
    self[Cfg.locale] = value
  end
end
