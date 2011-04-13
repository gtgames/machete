MongoMapper.connection = Mongo::Connection.new('192.168.159.254', nil, :logger => logger)

case Padrino.env
  when :development then MongoMapper.database = 'machete_development'
  when :production  then MongoMapper.database = 'machete_production'
  when :test        then MongoMapper.database = 'machete_test'
end
