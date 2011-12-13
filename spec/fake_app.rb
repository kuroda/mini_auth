# Create a rails app
# module Fake
  # class Application < Rails::Application
  # end
# end

# Establish connection to the database running on memory
ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => ":memory:"
)

# Define migration class
class CreateAllTables < ActiveRecord::Migration
  def change
    create_table(:users) { |t| t.string :name; t.string :password_digest }
  end
end

# Run migrations
migration = CreateAllTables.new
migration.verbose = false
migration.change

# Models
class User < ActiveRecord::Base
  include MiniAuth
end
