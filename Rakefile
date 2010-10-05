##############################################################################
# variables
##############################################################################

require 'rubygems'
require 'rake/remote_task'

APP_NAME = "skeleton.com"
APP_USER = "skeleton"
APP_DB = "postgres"
APP_DB_PASSWORD = ""



TEMP_FOLDER = "/home/#{APP_USER}/tmp/"
DEPLOY_ROOT = "/home/#{APP_USER}/www/#{APP_NAME}"
SERVER = "#{APP_USER}@ frenz:"

DEPLOY_FILES= %w(
  admin
  app
  config
  config.ru
  db
  lib
  locale
  imagination
  unicorn.rb
).join(' ')

IGNORE_FILES= %w(
  *._*
  *.DS_Store
).map{|f| "--exclude='#{f}'"}.join(' ')


role :app_server, "tazzo"
set :rsync_flags, ['-avzP']


##############################################################################
# tasks
##############################################################################
@archive = "#{APP_NAME}-#{`git rev-list --max-count=1 --abbrev=10 --abbrev-commit HEAD`.chomp}.tar.bz2"

def restart_daemons
  begin
    run "kill -QUIT $(cat #{DEPLOY_ROOT}/unicorn.pid)"
  rescue Rake::CommandFailedError => e
    puts "WARNING: No server running: #{e}"
  end
end

def sync_public
  rsync 'public', SERVER+DEPLOY_ROOT
  run "ln -s -f -T #{DEPLOY_ROOT}/public #{DEPLOY_ROOT}/current/public"
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

namespace :db do
  desc "Seeds the whole crap"
  remote_task :migrate do
    run("cd #{DEPLOY_ROOT}; bundle exec padrino rake seed")
  end

  desc "Creates Lang table"
  remote_task :lang do
    require "sequel"
    DB = Sequel.connect("postgres://#{APP_USER}:#{APP_DB_PASSWORD}@127.0.0.1/#{APP_DB}")
    DB.run[
      'CREATE TABLE languages ( id serial NOT NULL, code character varying(50) NOT NULL, "name" character varying(50) NOT NULL, CONSTRAINT languages_pkey PRIMARY KEY (id))',
      'CREATE UNIQUE INDEX unique_languages_code ON languages USING btree (code)'
    ]
  end
end
