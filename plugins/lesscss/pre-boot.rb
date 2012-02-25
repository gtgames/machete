##
# Compile less to css
#


puts 'Compiling less files'

path = ::File.expand_path('../public/stylesheets', __FILE__)

Dir.glob(::File.expand_path('../public/stylesheets/*.less', __FILE__)) do |f|
  f = f.sub(path, '').sub(/^\//, '')
  c = f.sub(/less$/, 'css')
  puts "compiling #{path} / #{f}"
  `cd #{path} && lessc #{f} > #{c}`
end
