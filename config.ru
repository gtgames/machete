require 'rack'
require 'em-net-http'
require 'em-resolv-replace'
require 'rack/fiber_pool'

use Rack::FiberPool


if ENV["RACK_ENV"] == "development"
  require ::File.dirname(__FILE__) + '/lib/gc_stats.rb'
  use GCStats
end

require ::File.dirname(__FILE__) + '/config/boot.rb'
run Padrino.application