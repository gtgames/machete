Sequel::Model.plugin(:schema)
Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure
Sequel::Model.plugin :force_encoding, 'UTF-8'
DB = case Padrino.env
  when :development then Sequel.connect("postgres://lor@127.0.0.1/frontend_development",  :loggers => [logger])
  when :production  then Sequel.connect("postgres://lor@127.0.0.1/frontend_development",  :loggers => [logger])
  when :test        then Sequel.connect("postgres://127.0.0.1/frontend_test",             :loggers => [logger])
end
