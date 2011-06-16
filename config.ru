#!/usr/bin/env rackup

$LOAD_PATH.unshift ::File.expand_path('../lib_core', __FILE__) # this sucks ... but what can i do?
require 'eventmachine'

require 'rack/fiber_pool'
use Rack::FiberPool

APP_ROOT = ::File.expand_path('../', __FILE__)

if ENV['RACK_ENV'] == 'development'
  require 'gc_stats'
  require 'logger'
  use Rack::MemoryBloat, Logger.new(STDOUT)

  use Rack::Static,
    :urls => ["/stylesheets", "/images"],
    :root => "public"
end

require ::File.expand_path('../config/boot.rb', __FILE__)
run Padrino.application
