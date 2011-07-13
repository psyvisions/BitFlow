$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require "rvm/capistrano"                  # Load RVM's capistrano plugin.


set :application, "BitFlow"
set :repository,  "git@github.com:pjc/BitFlow.git"
set :scm, :git
set :use_sudo, false
set :branch, 'master'
set :notification_address, "sreeix@gmail.com"
set :deploy_to, "/apps/#{application}"
set :rvm_ruby_string, 'ruby-1.9.2-p180@BitFlow'
set :rvm_type, :user

set :stages, %w(staging production)
set :default_stage, 'staging'

set :deploy_via, :remote_cache
set :rails_env, 'production'
set :normalize_asset_timestamps, false  # does not normalize the javascript/stylesheets etc.

before 'deploy:migrate', 'bitflow:copy_config'

namespace :bitflow do
  desc "copies db configs to the right place"
  task :copy_config do
    run " cp -f #{release_path}/sf/config/deploy/#{stage}/database.yml #{release_path}/sf/config/database.yml"
  end
end
