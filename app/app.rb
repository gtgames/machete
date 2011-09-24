class Machete < BasicApplication
  set :views, Padrino.root('templates')
  layout Cfg.layout(:machete)
  
  register PadrinoFields
  set :default_builder, 'PadrinoFieldsBuilder'
  PadrinoFields::Settings.configure do |config|
    config.container = :div
    config.label_required_marker = "<abbr>*</abbr>"
    config.label_required_marker_position = :append
  end
end
