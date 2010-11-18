# encoding:utf-8
class Admin < Padrino::Application
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl

  register Padrino::Contrib::ExceptionNotifier
  set :exceptions_from,    "mail@#{DOMAIN_NAME}"
  set :exceptions_to,      "exceptions@frenzart.com"
  set :exceptions_subject, "[#{DOMAIN_NAME}][Admin] "
  set :exceptions_page,    :errors
  
  set :delivery_method, :smtp => {
    :address              => "mail.gtgames.it",
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

  set :login_page, "/sessions/new"
  disable :store_location

  set :frontend_url, "http://#{DOMAIN_NAME}/"

  access_control.roles_for :any do |role|
    role.protect "/"
    role.allow "/sessions"
  end

  not_found do
    render '404'
  end

  access_control.roles_for :admin do |role|
    role.project_module :posts,     "/posts"
    role.project_module :menus,     "/menus"
    role.project_module :pages,     "/pages"
    role.project_module :media,     "/media"
    role.project_module :photos,    "/photos"
    role.project_module :aphorisms, "/aphorisms"
    role.project_module :accounts,  "/accounts"
  end

  before do
    headers 'Cache-Control' => "private, max-age=0, no-cache, must-revalidate"
    content_type :html, 'charset' => 'utf-8'
  end
end
