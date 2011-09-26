#!/usr/bin/env rackup
require 'rack/fiber_pool'
require 'eventmachine'

##
# Compile less to css
#
Process.fork do
  #Process.detach(1)
  # compile less files in a fork
  puts 'Compiling less files'
  path = ::File.expand_path('../public/stylesheets', __FILE__)
  Dir.glob(::File.expand_path('../public/stylesheets/*.less', __FILE__)) {|f|
    f = f.sub(path, '').sub(/^\//, '')
    puts "compiling #{path} / #{f}" 
    `cd #{path} && lessc #{f} > #{f.sub(/less$/, 'css')} --compress`
  }
end

use Rack::FiberPool

# Rack::Thumb thumb server
require ::File.expand_path('../lib/rack_thumb', __FILE__)
use Rack::Thumb, { :write => ENV['RACK_ENV'] == 'test' }

require ::File.expand_path('../config/boot.rb', __FILE__)
run Padrino.application
