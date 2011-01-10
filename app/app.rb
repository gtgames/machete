class Frontend < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers

  register Padrino::Contrib::ExceptionNotifier
  set :exceptions_from,    "mail@#{DOMAIN_NAME}"
  set :exceptions_to,      "exceptions@frenzart.com"
  set :exceptions_subject, "[#{DOMAIN_NAME}][Frontend] "
  set :exceptions_page,    :errors

  set :delivery_method, :smtp => {
    :address              => "frenz",
    :port                 => 25,
    :enable_starttls_auto => false
  }

  enable :logger
  enable :sessions
  enable :flash

  set :charset, "utf8"

  set :haml, {
    :ugly   => true,
    :format => :html5
  }

  if File.exists?(PADRINO_ROOT + '/app/views/layouts/custom.haml')
    layout :custom
  else
    layout :application
  end

  not_found do
    render '404'
  end

  before do
    if File.exists?(PADRINO_ROOT + '._maintainance')
      render 'maintainance'
    end
  end
end
