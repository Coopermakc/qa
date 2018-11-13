# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "qa"
set :repo_url, "git@github.com:Coopermakc/qa.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qa"
set :deploy_user, "deployer"
# Default value for :linked_files is []
append :linked_files, "config/database.yml", ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"



# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
