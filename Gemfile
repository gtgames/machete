source :rubygems

# Project requirements
gem 'rake'
gem 'rack-flash'
gem 'thin'

#gem 'rack-cache' #!included

#gem 'em-net-http'
#gem 'em-resolv-replace'
gem 'rack-fiber_pool'
gem 'em-synchrony', '>=0.2.0'

# Component requirements
gem 'bcrypt-ruby', :require => "bcrypt"
gem 'yajl-ruby', :require => "yajl/json_gem"
gem 'builder'

gem 'mongo', '>=1.3.0'
gem 'bson_ext', '>=1.3.0', :require => "mongo"

gem 'mongo_mapper', '>=0.9.0'
#gem 'hunt'

group :development do
  gem 'ruby-debug19'
end

# Test requirements
group :test do
  gem 'faker'
  gem 'rr'
  gem 'riot'
  gem 'riot-mongo_mapper'
  gem 'machinist_mongo'
  gem 'machinist', :require => 'machinist/mongo_mapper'
  gem 'rack-test', :require => "rack/test"
end

group :development do
  gem 'wirb'
end

gem 'padrino-contrib'

gem 'nokogiri'
gem 'sanitize'
gem 'unidecode'

#gem 'rack-thumb', :git => 'https://github.com/vidibus/rack-thumb.git'
#gem 'mapel', :git => 'https://github.com/vidibus/mapel.git'

# Padrino
gem 'padrino', "0.9.23"
