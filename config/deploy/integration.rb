set :user, "deploy"
set :deploy_to, "/home/deploy/#{application}/integration"
set :rails_env, "integration"
server "192.34.57.165", :app, :web, :db, :primary => true