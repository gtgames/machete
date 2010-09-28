# encoding: UTF-8
DataMapper.logger = logger

case Padrino.env
  when :development then DataMapper.setup( :default, "sqlite3://#{Padrino.root('db', 'development.db')}")
  when :test then DataMapper.setup( :default, "sqlite3://#{Padrino.root('db', 'test.db')}")
  when :production then DataMapper.setup(:default,
    :adapter => 'postgres',
    :host => '127.0.0.1',
    :username => 'database_user',
    :password => 'database_password',
    :database => 'database_name')
end
