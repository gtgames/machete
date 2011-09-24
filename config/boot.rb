# Defines our constants
PADRINO_ENV  = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "development"  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..')) unless defined?(PADRINO_ROOT)

# Load Bundler
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, PADRINO_ENV)

#
# Machete Plugins
#
# TODO: Make something cleaner
JSON.parse(File.new(Padrino.root('config', 'config.json'), 'r'))['plugins'].each do |plugin|
  unless File.directory?( "#{PADRINO_ROOT}/module_#{plugin}" )
    puts "Linking #{PADRINO_ROOT}/plugins/#{plugin}/module_#{plugin} => #{PADRINO_ROOT}/module_#{plugin}"
    File.symlink "#{PADRINO_ROOT}/plugins/#{plugin}/module_#{plugin}", "#{PADRINO_ROOT}/module_#{plugin}"
    
    puts "Linking #{PADRINO_ROOT}/plugins/#{plugin}/templates/#{plugin} => #{PADRINO_ROOT}/templates/#{plugin}"
    File.symlink "#{PADRINO_ROOT}/plugins/#{plugin}/templates/#{plugin}", "#{PADRINO_ROOT}/templates/#{plugin}"

    if File.directory? "#{PADRINO_ROOT}/plugins/#{plugin}/mailers/#{plugin}"
      puts "Linking #{PADRINO_ROOT}/plugins/#{plugin}/mailers/#{plugin} => #{PADRINO_ROOT}/templates/mailers/#{plugin}"
      File.symlink "#{PADRINO_ROOT}/plugins/#{plugin}/mailers/#{plugin}", "#{PADRINO_ROOT}/templates/mailers/#{plugin}"
    end
  end
end
###

##
# Add here your before load hooks
#
Padrino.before_load do
  I18n.backend.class.send(:include, I18n::Backend::Fallbacks)
  require Padrino.root('lib','config')
  I18n.default_locale = Cfg['locales'].first

  Wand.executable = '/usr/bin/file'

  Padrino.cache = Padrino::Cache::Store::Mongo.new(
    MongoMapper.database, :size => 2, :max => 100, :collection => 'cache' )

  -> {
    # compile less files in a closure :P
    puts 'Compiling less files'
    path = Padrino.root('public', 'stylesheets')
    Dir.glob(Padrino.root('public', 'stylesheets', '*.less')) {|f|
      f = f.sub(Padrino.root('public', 'stylesheets'), '').sub(/^\//, '')
      puts "compiling #{path} / #{f}" 
      `cd #{path} && lessc #{f} > #{f.sub(/less$/, 'css')} --compress`
    }
  }.call()
end

##
# Add here your after load hooks
#
Padrino.after_load do
  # Middleware for locale redirection
  if Cfg['locales'].length > 1
    use Rack::AutoLocale,
      :host_blacklist => [/^(www\.)?admin\..*$/],
      :blacklist  => ['/media','/sitemap.xml', '/sitemap']
  end

  # Rack::Thumb thumb server
  use Rack::Thumb,
    :write => true,
    :prefix => '/media'

end

Padrino.load!
