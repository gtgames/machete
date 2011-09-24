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
    :address              => "127.0.0.1",
    :port                 => 25,
    :enable_starttls_auto => false
  }
  set :mailer_defaults, :from => "noreply@#{Cfg[:domain]}"

  # Exception mailer
  register Padrino::Contrib::ExceptionNotifier
  set :exceptions_from, "mail@#{Cfg[:domain]}"
  set :exceptions_to, "god@progettoca.se"
  set :exceptions_subject, "[#{Cfg[:domain]}]"
  set :exceptions_page, :errors

  # error handling
  error 404 do
    render 'errors/404'
  end
  error 500 do
    render 'errors/500'
  end
end

Padrino.configure_apps do
  enable :sessions
  set :session_secret, SecureRandom.base64(64)
end

Padrino.mount("Admin").to("/").host(/^(?:www\.)?admin\..*$/)

Cfg['apps'].each do |app, mountpoint|
  puts "Mounting App: #{app}..."
  Padrino.mount("#{app}").to("#{mountpoint.downcase}").host(/^(?!(admin|www\.admin)).*$/)
end unless Cfg['apps'].nil?

# This should have low priority
Padrino.mount("Machete").to("/").host(/^(?!(admin|www\.admin)).*$/)