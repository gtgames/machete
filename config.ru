RACK_ENV = 'production'

$_ROOT = ::File.dirname(__FILE__)
require ::File.dirname(__FILE__) + '/config/boot.rb'

use Rack::Cache,
  :verbose     => true,
  :metastore   => "file:#{$_ROOT}/cache/rack/meta",
  :entitystore => "file:#{$_ROOT}/cache/rack/body",
  :allow_revalidate => true

run Padrino.application
