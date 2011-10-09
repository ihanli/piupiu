set :stages, %w(staging production)
require 'capistrano/ext/multistage'

set :application, "piu piu"

set :scm, :git
set :repository,  "ihanli@piupiu.at:repos/piupiu.git"
set :branch, ENV["BRANCH"] || "master"
set :deploy_via, :remote_cache
#ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :user, "piupiu_deployment"
set :use_sudo, false

role :web, "piupiu.at"
role :app, "piupiu.at"
role :db,  "piupiu.at", :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :copy_config do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/mailers.yml #{release_path}/config/mailers.yml"
    run "ln -nfs #{shared_path}/config/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
  end
end

require "bundler/capistrano"

after "deploy:update_code", "deploy:copy_config"