class MuStore
  attr_reader :client, :options

  def initialize(options={})
    @client = Hash.new
    @options = options
    refresh!
  end

  def read(key)
    decode(client[key.to_s])
  end

  def write(key, value)
    client[key.to_s] = encode(value)
    @options[:collection].update(
      {'_id' => key.to_s},
      {'_id' => key.to_s, 'val' => value}, {:upsert => true, :safe => true})
  end

  def delete(key)
    read(key).tap { client.delete(key.to_s) }
  end

  def clear
    client.clear
  end

  def refresh!
    clear
    Yajl::Parser.parse( File.read( Padrino.root("config", "config.json") ) )['site'].each do |k,v|
      client[k.to_s] = encode(v)
    end
    @options[:collection].find({}).each do |c|
      client[c["_id"]] = encode(c["val"])
    end
  end

  def encode(value)
    Marshal.dump(value)
  end
  def decode(value)
    Marshal.load(value.to_s)
  end

  alias get read
  alias set write
  alias insert write

  alias []  read
  alias []= write

  # more methods

  def locale
    ( read('locales').include?(I18n.locale.to_s) )? I18n.locale.to_s : default_locale
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
    unless read('layouts')[controller].nil?
      read('layouts')[controller].to_sym
    else
      :"application.html"
    end
  end

end

Cfg = MuStore.new({
  collection: MongoMapper.database['configuration']
})
