# encoding: UTF-8
module MongoI18n
  class Store
    attr_reader :collection

    def initialize(collection)
      @collection = collection
    end

    def []=(key, value)
      key = key.to_s
      doc = {:_id => key, :value => value}
      collection.save(doc)
    end

    # alias for read
    def [](key, options=nil)
      if doc = collection.find_one(:_id => key.to_s)
        doc["value"].to_s
      end
    end

    def keys
      keys = []
      collection.find({}, :fields => ["_id"]).each do |row|
        keys.push(row["_id"])
      end
      keys
    end

    # Thankfully borrowed from Jodosha's redis-store
    # https://github.com/jodosha/redis-store/blob/master/lib/i18n/backend/redis.rb
    def available_locales
      locales = self.keys.map { |k| k =~ /\./; $` }
      locales.uniq!
      locales.compact!
      locales.map! { |k| k.to_sym }
      locales
    end
  end
end

I18NDB = Mongo::Connection.new('127.0.0.1', 27017).db('i18n')
I18NDB.authenticate('i18n', 'i18n')
I18n.backend = I18n::Backend::Chain.new(
  I18n::Backend::KeyValue.new(MongoI18n::Store.new(I18NDB['strings'])),
  I18n.backend)  