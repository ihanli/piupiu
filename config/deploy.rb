set :application, "piu piu"
set :repository,  "ihanli@78.47.120.167:repos/piupiu.git"

set :deploy_to, "/var/www/virtualhosts/beta/piupiu.at"
set :user, "piupiu_deployment"
set :use_sudo, false

set :scm, :git
set :branch, ENV["BRANCH"] || "master"
default_run_options[:pty] = true

role :web, "78.47.120.167"
role :app, "78.47.120.167"
role :db,  "78.47.120.167", :primary => true

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