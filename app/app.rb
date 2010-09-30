class Frontend < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers
  
  set :locales, Language.all.map {|x| x.code.to_sym } || [:it]
  register Frenz::AutoLocale

  enable :logger
  enable :sessions
  enable :flash

  set :charset, "utf8"

  set :base_title, "GTGames.it"

  layout :application

  before do
    headers "X-UA-Compatible" => "IE=edge,chrome=1"
    content_type :html, 'charset' => 'utf-8'
  end

  error 404 do
    render 'errors/404'
  end

end