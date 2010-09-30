RACK_ENV = 'production'
$_ROOT = ::File.dirname(__FILE__)
require ::File.dirname(__FILE__) + '/config/boot.rb'

run Padrino.application