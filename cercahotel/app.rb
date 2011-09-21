class Cercahotel < Padrino::Application
  # setting our view directory to a shared one
  register Padrino::Rendering
  set :views, Padrino.root('templates', 'cercahotel')
  layout :application

  register Padrino::Mailer
  register Padrino::Helpers

  # Exception mailer
  register Padrino::Contrib::ExceptionNotifier
  set :exceptions_from, "mail@#{Cfg[:domain]}"
  set :exceptions_to, "god@progettoca.se"
  set :exceptions_subject, "[CercaHotel][#{Cfg[:domain]}]"
  set :exceptions_page, :errors

  # Cache
  register Padrino::Cache
  set :cache, Padrino.cache
  enable :caching

  # Mailer
  set :delivery_method, :smtp => {
    :address              => "127.0.0.1",
    :port                 => 25,
    :enable_starttls_auto => false
  }
  enable  :sessions

  # Session Support
  enable :sessions
  enable :flash

  error 404 do
    render 'errors/404'
  end
  error 500 do
    render 'errors/500'
  end
end
