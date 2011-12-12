# Configure Rails envinronment
ENV["RAILS_ENV"] = "test"

require "rails/all"
require "rspec/rails"

# Pull in the fake rails app
require 'fake_app'

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Configure RSpec
RSpec.configure do |config|
  require 'rspec/expectations'
  config.include RSpec::Matchers
  config.mock_with :rspec
end
