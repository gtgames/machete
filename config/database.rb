database_name = case Padrino.env
  when :development then 'machete_development'
  when :production  then 'machete_production'
  when :test        then 'machete_test'
end

MongoODM.config = {
  :host => '192.168.159.254',
  :port => Mongo::Connection::DEFAULT_PORT,
  :database => database_name
}
