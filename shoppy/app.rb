class Shoppy < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers

  use Frenz::XUaCompatible

  set :locales, Language.all.map {|x| x.code.to_sym }
  register Frenz::AutoLocale

  register Frenz::RackCache if CACHING

  enable :logger
  enable :sessions
  enable :flash

  set :charset, "utf8"

  set :base_title, "GTGames.it Shop"

  layout :application

  before do
    content_type :html, 'charset' => 'utf-8'
  end

  error 404 do
    render 'errors/404'
  end
end
