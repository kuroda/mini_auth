source "http://rubygems.org"

rails_version = ENV['MINI_AUTH_RAILS_VERSION']

if rails_version == "edge"
  gem "rails", :git => "git://github.com/rails/rails.git"
elsif rails_version && rails_version.strip != ""
  gem "rails", rails_version
else
  gem "rails", ">= 3.1.0"
end

gem "bcrypt-ruby", "~> 3.0.0"

group :test do
  if rails_version && rails_version.strip == "3.2.0.rc1"
    gem "rspec-rails", "~> 2.8.0.rc2"
  else
    gem "rspec-rails", "~> 2.7.0"
  end
  gem "sqlite3", "~> 1.3.4"
  gem "database_cleaner", "~> 0.7.0"
end
