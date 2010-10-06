class Frontend < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers

  register Padrino::Contrib::ExceptionNotifier
  set :exceptions_from,    "exceptions@#{DOMAIN_NAME}"
  set :exceptions_to,      "exceptions@frenzart.com"

  set :delivery_method, :smtp => {
    :address              => "mail.#{DOMAIN_NAME}",
    :port                 => 465,
    :user_name            => "mail@#{DOMAIN_NAME}",
    :password             => 'kUYAnAg92guxoziT53',
    :authentication       => :plain,
    :enable_starttls_auto => true
  }

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