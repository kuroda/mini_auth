#!/bin/bash
#
# rbenv version

set -e

function run {
  gem list --local bundler | grep bundler || gem install bundler --no-ri --no-rdoc

  for version in 3.1.6 3.2.6
  do
    echo "Running bundle exec rspec spec against rails $version..."
    MINI_AUTH_RAILS_VERSION=$version bundle update rails
    MINI_AUTH_RAILS_VERSION=$version bundle exec rake spec
  done
}

export RBENV_VERSION=1.8.7-p358
run

export RBENV_VERSION=1.9.3-p194
run

echo 'Success!'
