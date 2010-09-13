# encoding: UTF-8
DataMapper.logger = logger

case Padrino.env
  when :development then DataMapper.setup( :default, :adapter => 'sqlite3', :database => Padrino.root('db', 'development.db'), :encoding => 'utf8' )
  when :test then DataMapper.setup( :default, :adapter => 'sqlite3', :database => Padrino.root('db', 'test.db'), :encoding => 'utf8' )
  when :production then DataMapper.setup(:default,
    :adapter => 'postgresql',
    :host => 'localhost',
    :username => 'database_user',
    :password => 'database_password',
    :database => 'database_name',
    :encoding => 'utf8' )
end
