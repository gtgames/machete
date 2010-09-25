RACK_ENV = 'production'

if RACK_ENV != 'development'
  %w( rake
    rack/flash
    rack/cache
    do_sqlite3
    data_mapper
    dm-tags
    dm-is-tree
    dm-is-remixable
    dm-accepts_nested_attributes
    dm-paperclip
    rdiscount
    unidecode
    padrino
  ).each {|l| require l }
end

$_ROOT = ::File.dirname(__FILE__)

require ::File.dirname(__FILE__) + '/config/boot.rb'

use Rack::Cache,
  :verbose     => true,
  :metastore   => "file:#{$_ROOT}/cache/rack/meta",
  :entitystore => "file:#{$_ROOT}/cache/rack/body",
  :allow_revalidate => true

run Padrino.application
