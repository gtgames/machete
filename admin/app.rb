class Admin < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl

  register PadrinoFields
  set :default_builder, 'PadrinoFieldsBuilder'
  PadrinoFields::Settings.configure do |config|
    config.container = :fieldset
    config.label_required_marker = "<abbr>*</abbr>"
    config.label_required_marker_position = :append
  end

  use Rack::PostBodyContentTypeParser

  enable  :sessions

  set :session_secret, '28a4a90b149121c14172404245efdc8cb57a71d5679b487834f5b2dc1772105e'
  set :login_page, "/sessions/new"

  enable :store_location

  access_control.roles_for :any do |role|
    role.protect "/"
    role.allow "/sessions"
  end

  access_control.roles_for :admin do |role|
    role.project_module :links,     "/links"
    role.project_module :photos,    "/photos"
    role.project_module :posts,     "/posts"
    role.project_module :pages,     "/pages"
    role.project_module :accounts,  "/accounts"
  end
end
