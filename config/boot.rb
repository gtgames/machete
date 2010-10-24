BASE_TITLE = "GTgames"
DOMAIN_NAME = "frenz.fr"

#########################################################################################################
PADRINO_ENV  = ENV["PADRINO_ENV"] ||= ENV["RACK_ENV"] ||= RACK_ENV ||= "development"  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..')) unless defined?(PADRINO_ROOT)

begin
  # Require the preresolved locked set of gems.
  require File.expand_path('../../.bundle/environment', __FILE__)
rescue LoadError
  # Fallback on doing the resolve at runtime.
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end

Bundler.require(:default, PADRINO_ENV.to_sym)
puts "=> Located #{Padrino.bundle} Gemfile for #{Padrino.env}"


Padrino.before_load do
end

Padrino.after_load do
  DataMapper.finalize
end
require 'padrino-contrib/exception_notifier'
Padrino.load!
