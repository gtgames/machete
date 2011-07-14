class Admin < Padrino::Application
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl

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

  enable  :sessions

  set :session_secret, '28a4a90b149121c14172404245efdc8cb57a71d5679b487834f5b2dc1772105e'
  set :login_page, "/sessions/new"

  enable :store_location

  access_control.roles_for :any do |role|
    role.protect "/"
    role.allow "/sessions"
  end

  access_control.roles_for :root do |role|
    role.project_module :links,           "/links"
    role.project_module :photos,          "/photos"
    role.project_module :multimedia,      "/multimedia"
    role.project_module :posts,           "/posts"
    role.project_module :pages,           "/pages"
    role.project_module :taxonomy,        "/taxonomy"
    role.project_module :configurations,  "/configurations"
    role.project_module :accounts,        "/accounts"
  end

  ## ACL built from database or config.json
  Cfg[:acl].each_pair do |name, modules|
    access_control.roles_for name.to_sym do |role|
      modules.each do |m|
        role.project_module m.to_sym, "/#{m}"
      end
    end
  end

  before do
    headers 'Last-Modified' => Time.now.httpdate,
      "Expires" => "Fri, 01 Jan 1990 00:00:00 GMT",
      "Pragma" => "no-cache",
      "Cache-Control" => "no-cache, no-storem max-age=0, must-revalidate"
  end
end
