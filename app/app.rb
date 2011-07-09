class Machete < Padrino::Application
  # setting our view directory to a shared one
  register Padrino::Rendering
  set :views, Padrino.root('templates', 'app')
  layout :application

  register Padrino::Mailer
  register Padrino::Helpers

  # PadrinoFields (vendored and patched) in /lib/
  register PadrinoFields
  set :default_builder, 'PadrinoFieldsBuilder'
  PadrinoFields::Settings.configure do |config|
    config.container = :div
    config.label_required_marker = "<abbr>*</abbr>"
    config.label_required_marker_position = :append
  end

  # Exception mailer
  register Padrino::Contrib::ExceptionNotifier
  set :exceptions_from, "mail@#{Cfg[:domain]}"
  set :exceptions_to, "god@progettoca.se"
  set :exceptions_subject, "[machete][#{Cfg[:domain]}]"
  set :exceptions_page, :errors

  # Middleware for locale redirection
  if Cfg['locales'].length > 1
    use Rack::AutoLocale,
      :blacklist => ['/sitemap.xml', '/sitemap']
  end

  # Session Support
  enable :sessions
  enable :flash

  error 404 do
    render 'errors/404', :layout => 'layouts/application'
  end
end
