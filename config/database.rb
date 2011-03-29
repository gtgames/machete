
# Connection.new takes host, port
host = '192.168.159.254'
port = Mongo::Connection::DEFAULT_PORT

database_name = case Padrino.env
  when :development then 'machete_development'
  when :production  then 'machete_production'
  when :test        then 'machete_test'
end

Mongoid.database = Mongo::Connection.new(host, port).db(database_name)

Mongoid.raise_not_found_error = false
  
# You can also configure Mongoid this way
# Mongoid.configure do |config|
#   name = @settings["database"]
#   host = @settings["host"]
#   config.master = Mongo::Connection.new.db(name)
#   config.slaves = [
#     Mongo::Connection.new(host, @settings["slave_one"]["port"], :slave_ok => true).db(name),
#     Mongo::Connection.new(host, @settings["slave_two"]["port"], :slave_ok => true).db(name)
#   ]
# end
#
# More installation and setup notes are on http://mongoid.org/docs/
