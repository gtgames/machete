$LOAD_PATH.unshift ::File.expand_path('../lib_core', __FILE__) # this sucks ... but what can i do?
require 'eventmachine'

APP_ROOT = ::File.expand_path('../', __FILE__)

if ENV['RACK_ENV'] == 'development'
  require 'gc_stats'
  #use GCStats

  require 'logger'
  use Rack::MemoryBloat, Logger.new(STDOUT)

  use Rack::Static,
    :urls => ["/stylesheets", "/images"],
    :root => "public"
end

if EM.reactor_running?
  require 'rack/fiber_pool'
  use Rack::FiberPool
end

if ENV['RACK_ENV'] == 'production___'
  require "rack/cache"
  use Rack::Cache,
    :metastore   => "file:#{::File.expand_path('../cache', __FILE__)}/meta",
    :entitystore => "entitystore:#{::File.expand_path('../cache', __FILE__)}/body#cache"

  system("cd #{::File.expand_path('../public/stylesheets/less', __FILE__)} && /usr/bin/env lessc main.less > ../style.css")
end

require ::File.expand_path('../config/boot.rb', __FILE__)
run Padrino.application
