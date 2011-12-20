#!/bin/bash

set -e

if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
  source "/usr/local/rvm/scripts/rvm"
else
  printf "ERROR: An RVM installation was not found.\n"
fi

function run {
  gem list --local bundler | grep bundler || gem install bundler --no-ri --no-rdoc

  echo 'Running bundle exec rspec spec against rails 3.1.3...'
  MINI_AUTH_RAILS_VERSION=3.1.3 bundle update rails
  bundle exec rspec spec

  echo 'Running bundle exec rspec spec against rails 3.2.0.rc1...'
  MINI_AUTH_RAILS_VERSION=3.2.0.rc1 bundle update rails
  bundle exec rspec spec
}

rvm use ruby-1.8.7@mini_auth --create
run

rvm use ruby-1.9.3@mini_auth --create
run

echo 'Success!'
