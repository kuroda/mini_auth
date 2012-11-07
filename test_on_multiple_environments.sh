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

  for version in 3.1.8 3.2.8
  do
    echo "Running bundle exec rspec spec against rails $version..."
    MINI_AUTH_RAILS_VERSION=$version bundle update rails
    MINI_AUTH_RAILS_VERSION=$version bundle exec rspec spec
  done
}

rvm use ruby-1.8.7@mini_auth --create
run

rvm use ruby-1.9.3@mini_auth --create
run

echo 'Success!'
