##############################################################################
# variables
##############################################################################

require 'rubygems'
require 'rake/remote_task'

APP_NAME = "skeleton.com"
APP_USER = "skeleton"
UNBIT = false
TEMP_FOLDER = (UNBIT)? '/accounts/tazzo/tmp/' : "/home/#{APP_USER}/tmp/"
DEPLOY_ROOT = (UNBIT)? "/accounts/tazzo/www/#{APP_NAME}" : "/home/#{APP_USER}/www/#{APP_NAME}"
SERVER = (UNBIT)? "tazzo:" : "#{APP_USER}@ frenz:"

DEPLOY_FILES= [
  'admin',
  'app',
  'config',
  'config.ru',
  'db',
  'lib',
  # additional files/folders
  'locale',
  'imagination'
].join(' ')

IGNORE_FILES= [
  # temp files
  '*._*',
  '*.DS_Store',
  # additional crap-files
  ''
].map{|f| "--exclude='#{f}'"}.join(' ')


UNICORN_RB = <<-RUBY
env = 'production'

working_directory "#{DEPLOY_ROOT}/current"

worker_processes 2 # Master + 2 workers + app's background tasks
pid "#{DEPLOY_ROOT}/unicorn.pid"
stderr_path "#{DEPLOY_ROOT}/logs/unicorn.log"

#REE stuff
preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true
RUBY

role :app_server, "tazzo"
set :rsync_flags, ['-avzP']


##############################################################################
# tasks
##############################################################################
#TODO: add log reading task

@archive = "#{APP_NAME}-#{`git rev-list --max-count=1 --abbrev=10 --abbrev-commit HEAD`.chomp}.tar.bz2"

def restart_daemons
  begin
    run "kill -QUIT $(cat #{DEPLOY_ROOT}/unicorn.pid)"
  rescue Rake::CommandFailedError => e
    puts "WARNING: No server running: #{e}"
  end
end

def sync_unicorn_rb
  run "if [ -f '#{DEPLOY_ROOT}/unicorn.rb' ]; then rm #{DEPLOY_ROOT}/unicorn.rb; fi"
  put DEPLOY_ROOT, 'unicorn.rb'  do
    UNICORN_RB
  end
  run "mv #{DEPLOY_ROOT}/unicorn.rb* #{DEPLOY_ROOT}/unicorn.rb"
end

def sync_public
  rsync 'public', SERVER+DEPLOY_ROOT
  run "ln -s -f -T #{DEPLOY_ROOT}/public #{DEPLOY_ROOT}/current/public"
end

def db_upgrade(type)
  d = <<-RUBY
class Padrino
  def self.env;:production; end
  def self.root(*args)
    "#{DEPLOY_ROOT}/current/#{args.join('/')}"
  end
end
require 'rubygems'
PADRINO_ENV = 'production'
PADRINO_ROOT =  "#{DEPLOY_ROOT}/current"
File.read("#{DEPLOY_ROOT}/current/config.ru").each { |gem|
  require /\'([\w\-\_\/]*)\'/.match(gem)[1] if gem =~ /^(\s*)?require\s\'(do\_.*|dm\-.*|data_mapper)\'$/
}
File.read("#{DEPLOY_ROOT}/current/config/database.rb").each { |l|
  eval(/^.*:production then (DataMapper.setup\(.*\))/.match(l)[1]) if l =~ /^.*:production\sthen.*/
}
Dir["#{DEPLOY_ROOT}/current/*/models/*.rb"].each {|file| require file.sub(/\.rb$/, '') }

DataMapper::auto_#{type}!
RUBY
  d
end


namespace :deploy do
  task :build do
    puts "Building archive: #{@archive}"
    sh "tar cvzf #{@archive} #{IGNORE_FILES} #{DEPLOY_FILES}"
  end

  remote_task :push => :build do
    rsync @archive, SERVER+TEMP_FOLDER
  end

  desc "Install a release from the latest commit"
  remote_task :install => :push do
    date_stamp = Time.now.strftime("%Y%m%d")
    last_release = run("ls #{DEPLOY_ROOT}/rels | sort -r | head -n 1").chomp

    if last_release =~ /#{date_stamp}\.(\d+)/
      serial = $1.to_i + 1
    else
      serial = 0
    end

    rel = ("%d.%03d" % [date_stamp, serial])
    rel_dir = "#{DEPLOY_ROOT}/rels/#{rel}"

    run "mkdir -p #{rel_dir}"
    run "tar xzvf #{TEMP_FOLDER}/#{@archive} -C #{rel_dir} && rm -rf #{TEMP_FOLDER}/#{@archive}"
    run "ln -s -f -T #{rel_dir} #{DEPLOY_ROOT}/current"

    if run("if [ -d '#{DEPLOY_ROOT}/public' ]; then ln -s -f -T  #{DEPLOY_ROOT}/public #{rel_dir}/public;else echo '0'; fi").chomp == '0'
      sync_public
    end
    sync_unicorn_rb
    restart_daemons
  end


  desc "Rollback to the previous release"
  remote_task :rollback do
    current_link = run("ls -alF #{DEPLOY_ROOT} | awk '/current -> .*/ { print $NF }'").chomp
    current = File.basename(current_link)
    releases = run("ls #{DEPLOY_ROOT}/rels | sort -r").split("\n")
    previous = releases.find {|rel| current > rel}
    raise "No previous release" if previous.nil?
    run "ln -s -f -T #{DEPLOY_ROOT}/rels/#{previous} #{DEPLOY_ROOT}/current"
    restart_daemons
    puts "Moved to #{previous}"
  end

  desc "Rollforward to the next release"
  remote_task :rollforward do
    current_link = run("ls -alF #{DEPLOY_ROOT} | awk '/current -> .*/ { print $NF }'").chomp
    current = File.basename(current_link)
    releases = run("ls #{DEPLOY_ROOT}/rels | sort -r").split("\n")
    next_rel = releases.find {|rel| current < rel}
    raise "No next release" if next_rel.nil?
    run "ln -s -f -T #{DEPLOY_ROOT}/rels/#{next_rel} #{DEPLOY_ROOT}/current"
    restart_daemons
    puts "Moved to #{next_rel}"
  end

  desc "Upload and setup of the static files"
  remote_task :assets do
    sync_public
  end
end

namespace :server do
  desc "uploads app-server configuration"
  remote_task :config do
    sync_unicorn_rb
  end

  desc "Restart server"
  remote_task :restart do
    restart_daemons
  end
end

namespace :db do

  desc "Upgrades the db to the current scheme"
  remote_task :upgrade do
    run "if [ -f '#{DEPLOY_ROOT}/db_upgrade.rb' ]; then rm #{DEPLOY_ROOT}/unicorn.rb; fi"
    put DEPLOY_ROOT, 'db_upgrade.rb'  do
      db_upgrade('upgrade')
    end
    run "ruby #{DEPLOY_ROOT}/db_upgrade.rb*"
  end

  desc "Reinitializes db with the current scheme"
  remote_task :migrate do
    run "if [ -f '#{DEPLOY_ROOT}/db_upgrade.rb' ]; then rm #{DEPLOY_ROOT}/unicorn.rb; fi"
    put DEPLOY_ROOT, 'db_upgrade.rb' do
      db_upgrade('migrate')
    end
    run "ruby #{DEPLOY_ROOT}/db_upgrade.rb*"
  end

end

namespace :log do
  remote_task :read, :lines do |t, args|
    args.with_defaults :lines => 45
    puts run("tail -n #{args.lines} #{DEPLOY_ROOT}/logs/unicorn.log")
  end
  
  remote_task :download, :dir do |t, args|
    args.with_defaults :dir => './'
    get './', "#{DEPLOY_ROOT}/logs/unicorn.log"
  end
end