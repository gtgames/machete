require ::File.dirname(__FILE__) + '/config/boot.rb'
require 'rack/fiber_pool'
use Rack::FiberPool

run Padrino.application