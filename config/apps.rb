class BasicApplication < Padrino::Application
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers

  set :views, Padrino.root('templates')

  # Cache
  register Padrino::Cache
  set :cache, Padrino.cache
  enable :caching

  # Mailer
  set :delivery_method, :smtp => {
    :address              => "frenz",
    :port                 => 25,
    :enable_starttls_auto => false
  }
  set :mailer_defaults, :from => "noreply@#{Cfg[:domain]}"

  # Exception mailer
  register Padrino::Contrib::ExceptionNotifier
  set :exceptions_from, "mail@#{Cfg[:domain]}"
  set :exceptions_to, "god@progettoca.se"
  set :exceptions_subject, "M][Apps][#{Cfg[:domain]}"

  set :exceptions_page_500, "errors/500"
  set :exceptions_page_404, "errors/404"
  
  use Rack::Session::Cookie, :key => 'rack.session'
  register Padrino::Contrib::Helpers::Flash

  # Middleware for locale redirection
  if Cfg['locales'].length > 1
    puts "Using Locale Middleware"
    require Padrino.root('lib','simple_locale')

    use Rack::AutoLocale,
      :host_blacklist => /^(www\.)?admin\..*$/,
      :blacklist  => lambda{
        blacklist = ['/media','/sitemap.xml', '/sitemap']
        for k,v in Cfg["apps"] do
          blacklist << v
        end
      }.call()
  end
end

Padrino.configure_apps do
  enable :sessions
  set :session_secret, Digest::SHA256.hexdigest(Padrino.root)
end

#
# Machete Plugins
# lib/plugger.rb
PluginManager(JSON.parse(File.read(Padrino.root('config', 'config.json')))['plugins'])

Padrino.mount("Admin").to("/").host(/^(?:www\.)?admin\..*$/)

# This should have low priority
Padrino.mount("Machete").to("/").host(/^(?!(admin|www\.admin)).*$/)