source "http://rubygems.org"

rails_version = ENV['MINI_AUTH_RAILS_VERSION']

if rails_version == "edge"
  gem "rails", :git => "git://github.com/rails/rails.git"
elsif rails_version && rails_version.strip != ""
  gem "rails", rails_version
else
  gem "rails", ">= 3.2.6"
end

gem "bcrypt-ruby", "~> 3.0.1"

group :test do
  gem "rspec-rails", "~> 2.11.0"
  gem "sqlite3", "~> 1.3.4"
  gem "database_cleaner", "~> 0.7.0"
end
