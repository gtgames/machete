class Admin < Padrino::Application
  register Padrino::Rendering
  set :views, Padrino.root('templates')
  
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Contrib::ExceptionNotifier
  
  register Padrino::Admin::AccessControl

  register PadrinoFields
  set :default_builder, 'PadrinoFieldsBuilder'
  PadrinoFields::Settings.configure do |config|
    config.container = :div
    config.label_required_marker = "<abbr>*</abbr>"
    config.label_required_marker_position = :append
  end

  enable  :sessions

  set :login_page, "/sessions/new"

  layout "/admin/layouts/application"

  enable :store_location

  access_control.roles_for :any do |role|
    role.protect "/"
    role.allow "/sessions"
  end

  ## ACL built from database or config.json
  Cfg[:acl].each_pair do |name, modules|
    access_control.roles_for name.to_sym do |role|
      modules.each do |m|
        role.project_module m.to_sym, "/#{m}"
      end
    end
  end
  
  error 404 do
    render 'errors/404'
  end
  error 500 do
    render 'errors/500'
  end
end

JSON.parse(File.new(Padrino.root('config', 'config.json'), 'r'))['plugins'].each do |plugin|
  require "#{PADRINO_ROOT}/plugins/#{plugin}/admin"
end
