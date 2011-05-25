class Translation < String
  attr_accessor :keys

  def initialize(*args)
    super
    @keys = {}
    @keys["default"] = "it"
  end

  def []=(lang, text)
    @keys[lang.to_s] = text
  end

  def [](lang)
    @keys[lang.to_s]
  end

  def languages
    langs = @keys.keys
    langs.delete("default")
    langs
  end

  def default_language=(lang)
    @keys["default"] = lang
    self.replace(@keys[lang.to_s])
  end

  def self.build(keys, default = "it")
    tr = self.new
    tr.keys = keys
    tr.default_language = default
    tr
  end

  def self.to_mongo(value)
    return value.keys if value.kind_of?(self)

    @keys
  end

  def self.from_mongo(value)
    return value if value.kind_of?(self)

    result = self.new
    result.keys = (value.nil?)? {} : value
    result.default_language = (value.nil?)? "it" : value["default"]

    result
  end
end
