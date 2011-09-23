class Machete < Padrino::Application
  set :views, Padrino.root('templates')
  layout Cfg.layout(:machete)
end
