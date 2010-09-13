RACK_ENV = 'production'

if RACK_ENV != 'development'
  require 'rake'
  require 'rack/flash'
  require 'rack/cache'

  require 'do_sqlite3'
  require 'data_mapper'
  require 'dm-tags'
  require 'dm-is-tree'

  require 'dm-paperclip'

  require 'rdiscount'
  require 'unidecode'

  require 'padrino'
end

$_ROOT = ::File.dirname(__FILE__)

require ::File.dirname(__FILE__) + '/config/boot.rb'

use Rack::Cache,
  :verbose     => true,
  :metastore   => "file:#{$_ROOT}/cache/rack/meta",
  :entitystore => "file:#{$_ROOT}/cache/rack/body",
  :allow_revalidate => true

run Padrino.application
