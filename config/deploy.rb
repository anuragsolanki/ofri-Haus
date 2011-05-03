set :application, "shapado"
set :repository,  "git@github.com:anuragsolanki/ofri-Haus.git"

set :keep_releases, 3

set :scm, :git
set :branch, 'master'
set :user, 'deploy'
set :use_sudo, false
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1

# task :production do
  # set :application, "shapado"
  set :deploy_to, "/var/www/#{application}"
  set :rails_env, "production"
  role :app, "72.14.190.103"
  role :web, "72.14.190.103"
  role :db, "72.14.190.103", :primary => true
# end

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
  task :after_symlink, :roles => :app do
    run "cp #{shared_path}/database.yml #{current_path}/config/database.yml"
    run "cp #{shared_path}/shapado.yml #{current_path}/config/shapado.yml"
  end
  
  desc "Run cleanup after long_deploy"
  task :after_deploy do
    cleanup
  end
  
end