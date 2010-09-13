class Frontend < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers

  use Frenz::XUaCompatible

  unless MULTILANGUAGE_APP.nil?
    set :localized, true
    set :locales, MULTILANGUAGE_APP
    register Frenz::AutoLocale
  else
    set :localized, true
  end
  
  register Frenz::RackCache if CACHING

  enable :logger
  enable :sessions
  enable :flash

  set :charset, "utf8"

  set :base_title, "GTGames.it"

  layout :application

  before do
    content_type :html, 'charset' => 'utf-8'
  end

  error 404 do
    render 'errors/404'
  end
end
