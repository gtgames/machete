class Machete < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Rendering

  register PadrinoFields
  set :default_builder, 'PadrinoFieldsBuilder'
  PadrinoFields::Settings.configure do |config|
    config.container = :div
    config.label_required_marker = "<abbr>*</abbr>"
    config.label_required_marker_position = :append
  end

  enable :sessions
  enable :flash

  layout  :application

  error 404 do
    render 'errors/404'
  end
end
