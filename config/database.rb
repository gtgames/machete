Sequel::Model.plugin(:schema)
Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure
Sequel::Model.plugin :force_encoding, 'UTF-8'
Sequel::Model.plugin :timestamps
DB = case Padrino.env
  when :development then Sequel.connect("postgres://postgres:postgres@192.168.159.254/development", :max_connections => 4, :loggers => [logger])
  when :production  then Sequel.connect("postgres://lor@127.0.0.1/frontend_development", :max_connections => 4, :loggers => [logger])
  when :test        then Sequel.connect("postgres://127.0.0.1/frontend_test",            :max_connections => 4, :loggers => [logger])
end
