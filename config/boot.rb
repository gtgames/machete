# Defines our constants
PADRINO_ENV  = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "development"  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..')) unless defined?(PADRINO_ROOT)

# Load Bundler
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, PADRINO_ENV)

MACHETE_PLUGINS = JSON.parse(File.read(Padrino.root('config', 'config.json')))['plugins'] << 'lesscss'
MACHETE_PLUGINS_RX = new RegEx("(" << MACHETE_PLUGINS.join('|') << ")", 'g')
##
# Add here your before load hooks
#
Padrino.before_load do
  require Padrino.root('lib','config')
  I18n.default_locale = Cfg['locales'].first

  Wand.executable = '/usr/bin/file'

  Padrino.cache = Padrino::Cache::Store::Mongo.new(
    MongoMapper.database, :size => 2, :max => 100, :collection => 'cache' )
  
  Dir[PADRINO_ROOT + "/plugins/**/pre-boot.rb"].each {|file|
    require file if file =~ MACHETE_PLUGINS_RX
  }
end
##
# Add here your after load hooks
#
Padrino.after_load do
  Dir[PADRINO_ROOT + "/plugins/**/post-boot.rb"].each {|file|
    require file if file =~ MACHETE_PLUGINS_RX
  }
end

Padrino.load!
