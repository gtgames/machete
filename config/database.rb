require 'yajl/json_gem'

settings = JSON.parse(File.new(Padrino.root('config', 'config.json'), 'r'))

MongoMapper.connection = Mongo::Connection.new(settings['mongo']['host'], nil, :logger => logger)

case Padrino.env
  when :development then MongoMapper.database = settings['mongo']['name'] + '_development'
  when :production  then MongoMapper.database = settings['mongo']['name']
  when :test        then MongoMapper.database = settings['mongo']['name'] + '_test'
end

MongoMapper.database.authenticate(settings['mongo']['user'], settings['mongo']['password']) unless (settings['mongo']['user']).nil?