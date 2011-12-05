#!/usr/bin/env rackup
#encoding: utf-8
require 'rack/fiber_pool'
require 'eventmachine'

##
# Compile less to css
#
lambda {
  # compile less files in a fork
  puts 'Compiling less files'
  path = ::File.expand_path('../public/stylesheets', __FILE__)
  Dir.glob(::File.expand_path('../public/stylesheets/*.less', __FILE__)) {|f|
    f = f.sub(path, '').sub(/^\//, '')
    c = f.sub(/less$/, 'css')
    puts "compiling #{path} / #{f}"
    `cd #{path} && lessc #{f} > #{c}`
  }
}.call()

use Rack::FiberPool

# Rack::Thumb thumb server
require ::File.expand_path('../lib/rack_thumb', __FILE__)
use Rack::Thumb, { :write => ENV['RACK_ENV'] == 'production' }

require ::File.expand_path('../config/boot.rb', __FILE__)
run Padrino.application
