#!/usr/bin/env rackup
#encoding: utf-8
require 'rack/fiber_pool'
require 'eventmachine'

use Rack::FiberPool

# Rack::Thumb thumb server
require ::File.expand_path('../lib/rack_thumb', __FILE__)
use Rack::Thumb, { :write => ENV['RACK_ENV'] == 'production' }

require ::File.expand_path('../config/boot.rb', __FILE__)
run Padrino.application
