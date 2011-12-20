# Configure Rails envinronment
ENV["RAILS_ENV"] = "test"

require "rails/all"
require "rspec/rails"
require 'database_cleaner'
require "mini_auth"

# Pull in the fake rails app
require 'fake_app'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Configure RSpec
RSpec.configure do |config|
  require 'rspec/expectations'
  config.include RSpec::Matchers
  config.mock_with :rspec
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation, :except => %w())
  end
  
  config.before(:each) do
    DatabaseCleaner.start
  end
  
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
