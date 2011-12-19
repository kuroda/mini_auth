# Establish connection to the database running on memory
ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => ":memory:"
)

# Discard ActiveRecord's log
ActiveRecord::Base.logger = Logger.new('/dev/null')

# Define migration class
class CreateAllTables < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :name
      t.string :password_digest
      t.string :auto_login_token
    end
  end
end

# Run migrations
migration = CreateAllTables.new
migration.verbose = false
migration.change

# Models
class User < ActiveRecord::Base
  include MiniAuth
  
  attr_accessible :name
end
