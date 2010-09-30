ENV['GEM_PATH'] = "#{ENV['HOME']}/lib/ruby/gems:/opt/ruby/gems/"
APP_ROOT = ::File::expand_path(File.dirname(__FILE__))

env = 'production'

working_directory ::File::expand_path(File.dirname(__FILE__))

worker_processes 2 # Master + 2 workers + app's background tasks
pid APP_ROOT + "unicorn.pid"
stderr_path APP_ROOT + "unicorn.log"

#REE stuff
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

before_fork do |server, worker|
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  old_pid = APP_ROOT + 'unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end