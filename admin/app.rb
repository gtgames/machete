# encoding:utf-8
class Admin < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl

  register Padrino::Contrib::ExceptionNotifier
  set :exceptions_from,    "mail@#{DOMAIN_NAME}"
  set :exceptions_to,      "god@progettoca.se"
  set :exceptions_subject, "[#{DOMAIN_NAME}][Admin] "
  set :exceptions_page,    :errors
  
  set :delivery_method, :smtp => {
    :address              => "127.0.0.1",
    :port                 => 25,
    :user_name            => "mail@#{DOMAIN_NAME}",
    :password             => 'kUYAnAg92guxoziT53',
    :authentication       => :plain
  }

  set :charset, "utf8"

  set :haml, {
    :ugly   => true,
    :format => :html5
  }

  use Rack::RawUpload, :paths => ['/media_browser/create/*']

  set :login_page, "/sessions/new"
  disable :store_location

  access_control.roles_for :any do |role|
    role.protect  "/"
    role.allow    "/sessions"
  end

  not_found do
    render '404'
  end

  access_control.roles_for :admin do |role|
    role.project_module :news,    "/posts"
    role.project_module :menu,    "/menus"
    role.project_module :pagine,  "/pages"
    role.project_module :media,   "/media"
    role.project_module :foto,    "/photos"
    role.project_module :aforismi,"/aphorisms"
    role.project_module :account, "/accounts"
  end

  before do
    headers 'Cache-Control' => "private, max-age=0, no-cache, must-revalidate"
    content_type :html, 'charset' => 'utf-8'
  end
end
