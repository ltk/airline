# airline

### Installation
    rvm --create --rvmrc 1.9.3@airline
    cd ../airline
    gem install bundler
    bundle
    cp config/database.yml.example config/database.yml

#### Edit config/database.yml with your local settings

    bundle exec rake db:create db:migrate
    bundle exec rails server
