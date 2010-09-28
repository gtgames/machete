ENV['GEM_PATH'] = "#{ENV['HOME']}/lib/ruby/gems:/opt/ruby/gems/"

env = 'production'

working_directory ::File::expand_path(File.dirname(__FILE__))

worker_processes 2 # Master + 2 workers + app's background tasks
pid ::File::expand_path(File.dirname(__FILE__)+"/unicorn.pid")
stderr_path ::File::expand_path(File.dirname(__FILE__)+"/unicorn.log")

#REE stuff
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true