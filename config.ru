require 'rack'
require 'em-net-http'
require 'em-resolv-replace'
require 'rack/fiber_pool'

use Rack::FiberPool

require ::File.dirname(__FILE__) + '/config/boot.rb'
run Padrino.application