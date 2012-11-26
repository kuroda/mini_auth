source "http://rubygems.org"

rails_version = ENV['MINI_AUTH_RAILS_VERSION']

if rails_version == "edge"
  gem "rails", :git => "git://github.com/rails/rails.git"
elsif rails_version && rails_version.strip != ""
  gem "rails", rails_version
else
  gem "rails", ">= 3.2.9"
end

gem "bcrypt-ruby", "~> 3.0.1"

group :test do
  gem "rspec-rails", "~> 2.12.0"
  gem "sqlite3", "~> 1.3.6"
  gem "database_cleaner", "~> 0.9.1"
end
