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

  set :exceptions_page_500, "errors/500"
  set :exceptions_page_404, "errors/404"
  
  use Rack::Session::Cookie, :key => 'rack.session'

  register Padrino::Contrib::Helpers::Flash
end

Padrino.configure_apps do
  enable :sessions
  set :session_secret, SecureRandom.base64(64)
end

#
# Machete Plugins
#
# TODO: Make something cleaner
JSON.parse(File.read(Padrino.root('config', 'config.json')))['plugins'].each do |plugin|
  begin
    unless File.directory?( "#{PADRINO_ROOT}/templates/#{plugin}" )
      puts "Linking #{PADRINO_ROOT}/plugins/#{plugin}/templates/#{plugin} => #{PADRINO_ROOT}/templates/#{plugin}"
      File.symlink "#{PADRINO_ROOT}/plugins/#{plugin}/templates/#{plugin}", "#{PADRINO_ROOT}/templates/#{plugin}"

      if File.directory?("#{PADRINO_ROOT}/plugins/#{plugin}/mailers/#{plugin}") and not File.directory?("#{PADRINO_ROOT}/templates/mailer/#{plugin}")
        puts "Linking #{PADRINO_ROOT}/plugins/#{plugin}/mailers/#{plugin} => #{PADRINO_ROOT}/templates/mailers/#{plugin}"
        File.symlink "#{PADRINO_ROOT}/plugins/#{plugin}/mailers/#{plugin}", "#{PADRINO_ROOT}/templates/mailers/#{plugin}"
      end
    end
  rescue Errno::EEXIST
    # do nothing
  end
  Padrino.set_load_paths("#{PADRINO_ROOT}/plugins/#{plugin}", "#{PADRINO_ROOT}/plugins/#{plugin}/models")
  require "#{PADRINO_ROOT}/plugins/#{plugin}/app"
  Dir.glob("#{PADRINO_ROOT}/plugins/#{plugin}/models/*.rb").each{|r| require r.sub(/\.rb$/, '') }
end
###




Padrino.mount("Admin").to("/").host(/^(?:www\.)?admin\..*$/)

Cfg['apps'].each do |app, mountpoint|
  begin
    Object.const_get(app) # testing app existance

    puts "Mounting App: #{app}..."
    Padrino.mount("#{app}").to("#{mountpoint.downcase}").host(/^(?!(admin|www\.admin)).*$/)
  rescue NameError
    # do nothing
    logger.error "not mounting #{app}"
  end
end unless Cfg['apps'].nil?

# This should have low priority
Padrino.mount("Machete").to("/").host(/^(?!(admin|www\.admin)).*$/)