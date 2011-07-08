class Machete < Padrino::Application
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  register PadrinoFields
  set :default_builder, 'PadrinoFieldsBuilder'
  PadrinoFields::Settings.configure do |config|
    config.container = :div
    config.label_required_marker = "<abbr>*</abbr>"
    config.label_required_marker_position = :append
  end

  register Padrino::Contrib::ExceptionNotifier
  set :exceptions_from, "mail@#{Cfg[:domain]}"
  set :exceptions_to, "god@progettoca.se"
  set :exceptions_subject, "[machete][#{Cfg[:domain]}]"
  set :exceptions_page, :errors

  use Rack::AutoLocale,
    :blacklist => ['/sitemap.xml', '/sitemap']

  enable :sessions
  enable :flash

  layout  :application

  error 404 do
    render 'errors/404'
  end
end
