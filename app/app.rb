class Frontend < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers

  register Padrino::Contrib::ExceptionNotifier
  set :exceptions_from,    "mail@#{DOMAIN_NAME}"
  set :exceptions_to,      "exceptions@frenzart.com"
  set :exceptions_subject, "Frontend"
  set :exceptions_page,    :errors

  set :delivery_method, :smtp => {
    :address              => "frenz",
    :port                 => 25,
    :enable_starttls_auto => false
  }

  use Rack::Recaptcha,
    :private_key => "6Lf6G74SAAAAAFCm5dB7VzAD9VKw2xTt3p5N41sR",
    :public_key => "6Lf6G74SAAAAAMSq_f-QtC2s2fcUg1hmzDHV5sDY",
    :paths => "/contattaci"
  helpers Rack::Recaptcha::Helpers

  enable :logger
  enable :sessions
  enable :flash

  set :charset, "utf8"

  layout :application

  before do
    content_type :html, 'charset' => 'utf-8'
  end
end
