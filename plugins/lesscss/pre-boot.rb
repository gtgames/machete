##
# Compile less to css
#


puts 'Compiling less files'

path = ::File.expand_path('../../../public/stylesheets', __FILE__)

Thread.new do
  `cd #{path} && ls *.less | awk '{print("lessc "$1" "$1)}' | sed 's/\\.less/\\.css/2' | /bin/bash`
end