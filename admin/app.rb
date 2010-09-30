# encoding:utf-8
class Admin < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl

  ##
  # Application configuration options
  #
  # set :raise_errors, true     # Show exceptions (default for development)
  # set :public, "foo/bar"      # Location for static assets (default root/public)
  # set :reload, false          # Reload application files (default in development)
  # set :default_builder, "foo" # Set a custom form builder (default 'StandardFormBuilder')
  # set :locale_path, "bar"     # Set path for I18n translations (default your_app/locales)
  # enable  :sessions           # Disabled by default
  # disable :flash              # Disables rack-flash (enabled by default if sessions)
  # layout  :my_layout          # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
  #
  helpers Frenz::AutoLocale::Helpers
  
  set :charset, "utf8"
  set :locales, Language.all.map {|x| x.code.to_sym }

  set :login_page, "/sessions/new"
  disable :store_location

  set :frontend_url, "http://#{DOMAIN_NAME}/"

  access_control.roles_for :any do |role|
    role.protect "/"
    role.allow "/sessions"
  end

  access_control.roles_for :admin do |role|
      role.project_module :shop, "/shop"
      role.project_module :menus, "/menus"
      role.project_module :pages, "/pages"
      role.project_module :photos, "/photos"
      role.project_module :aphorisms, "/aphorisms"
      role.project_module :languages, "/languages"
      role.project_module :accounts, "/accounts"
  end

  before do
    I18n.locale = get_browser_locale

    headers 'Cache-Control' => "private, max-age=0, no-cache, must-revalidate"
    headers 'Last-Modified' => Time.now.httpdate
    content_type :html, 'charset' => 'utf-8'
  end
end
