#!/usr/bin/env watchr
# vim: ft=ruby
#
# install watchr
# $ gem install watchr
#
# Run With:
# $ watchr test.watchr
#

# --------------------------------------------------
# Helpers
# --------------------------------------------------

def run(cmd)
  system("clear")
  puts("\n"*1)
  puts(cmd)
  puts("\n"*3)
  system("ruby #{cmd}")
end

# --------------------------------------------------
# Watchr Rules
# --------------------------------------------------
watch("^lib/(.*)\.rb") { |m| run("test/lib/#{m[1]}_test.rb") }

watch("^(.*)/controllers/(.*).rb") { |m| run("test/#{m[1]}/controllers/#{m[2]}_controller_test.rb") }
watch("^test/(.*)/controllers/(.*)_test.rb") { |m| run("test/#{m[1]}/controllers/#{m[2]}_test.rb") }

watch("^(.*)/controllers.rb") { |m| run("test/#{m[1]}/controllers_test.rb") }
watch("^test/(.*)/controllers_test.rb") { |m| run("test/#{m[1]}/controllers_test.rb") }

watch("^(.*)/models/(.*).rb") { |m| run("test/#{m[1]}/models/#{m[2]}_test.rb") }
watch("^test/(.*)/(.*)_test.rb") { |m| run("test/#{m[1]}/models/#{m[2]}_test.rb") }

watch("^models/(.*).rb") { |m| run("test/models/#{m[1]}_test.rb") }
watch("^test/models/(.*)_test.rb") { |m| run("test/models/#{m[1]}_test.rb") }

watch("test.*/test_config\.rb") { system( "rake test" ) }
watch("^test/(.*)_test\.rb") { |m| run("test/#{m[1]}_test.rb") }


# --------------------------------------------------
# Signal Handling
# --------------------------------------------------
# Ctrl-\
Signal.trap('QUIT') do
  system("clear")
  puts " --- Running all tests ---\n\n"
  system "padrino rake test"
end

# Ctrl-C
Signal.trap('INT') { abort("\n") }
