require 'adapter/memory'

Adapter.define(:configuration, Adapter::Memory) do
  def insert(k, v)
    MongoMapper.database["configurations"].update(
      {'_id' => k.to_s},
      {"_id" => k.to_s, "val" => v}, {:upsert => true, :safe => true})
    write k.to_s, v
  end

  def refresh!
    clear
    JSON.parse(File.read(Padrino.root("config", "config.json")))['site'].each do |k,v|
      write k,v
    end
    MongoMapper.database['configurations'].find({}).each do |c|
      write c["_id"], c["val"]
    end
  end

  def locale
    (read('locales').include?(I18n.locale.to_s))? I18n.locale : read('locales').first
  end
  alias :language :locale

  def acl role
    read(role)
  end
  def roles
    t = read('roles')
    return (t.nil?)? t['admin'] : t
  end
  def default_locale
    read('locales').first
  end

  def layout(controller)
    unless read('layouts').nil?
      read('layouts')[controller].to_sym || :"application.html"
    else
      :"application.html"
    end
  end
end

Cfg = Adapter[:configuration].new({})
Cfg.refresh!
