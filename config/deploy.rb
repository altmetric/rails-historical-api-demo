require 'bundler/capistrano'
require 'gnip/capistrano'
load "#{File.dirname(__FILE__)}/deploy/historical_managerator_tasks"

::NOT_SET = '<not set>'

setup_gnip_instances

default_run_options[:pty] = true

set :keep_releases, 5
set :application, 'historical-managerator'
set :repository, 'git@github.com:gnip/gnip-search-demo.git'
set :deploy_to, "/opt/gnip/#{application}"
set :deploy_via, :remote_cache
set :scm, :git
set :nginx_directory, '/opt/nginx1'
set :use_sudo, true
set :sudo, '/usr/bin/sudo'
set :ssh_options, forward_agent: true
set :rails_env, environment
set :yum_repo, 'review'

dump_settings

after 'deploy:setup', 'gnip:update_permissions'
after 'deploy:restart', 'deploy:cleanup'

%w(deploy:update_code).each do |after_task|
  after after_task, 'gems:install', 'gnip:write_out_version', 'gnip:update_permissions'
end

require './config/boot'
require 'airbrake/capistrano'
