# Defines our constants
PADRINO_ENV  = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= "development"  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..')) unless defined?(PADRINO_ROOT)

unless $LOAD_PATH.include? File.join(PADRINO_ROOT, 'lib_core')
  $LOAD_PATH.unshift File.join(PADRINO_ROOT, 'lib_core') # this sucks ... but what could i do?
end

# Load Bundler
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
Bundler.require(:default, PADRINO_ENV)
##
# Add here your before load hooks
#
Padrino.before_load do
  I18n.backend.class.send(:include, I18n::Backend::Fallbacks)
  require Padrino.root('lib','config')
  I18n.default_locale = Cfg['locales'].first

  Wand.executable = '/usr/bin/file'

  Padrino.cache = Padrino::Cache::Store::Mongo.new( MongoMapper.database, :size => 2, :max => 100, :collection => 'cache')
end

##
# Add here your after load hooks
#
Padrino.after_load do
end

Padrino.load!
