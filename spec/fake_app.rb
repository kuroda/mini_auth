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
      t.string :mail_confirmation_token
    end

    create_table(:members) do |t|
      t.string :name
      t.string :password_digest
    end

    create_table(:administrators) do |t|
      t.string :name
      t.string :password_digest
      t.boolean :deleted
    end

    create_table(:emails) do |t|
      t.string :address
      t.string :confirmation_token
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
  include MiniAuth::RandomToken
  
  token :auto_login
end

class Member < ActiveRecord::Base
  include MiniAuth
  attr_accessible :name
end

class Administrator < ActiveRecord::Base
  include MiniAuth
  attr_protected :deleted
end

class Email < ActiveRecord::Base
  include MiniAuth::RandomToken

  token :confirmation
end
