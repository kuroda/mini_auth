mini_auth
=========

A minimal authentication module for Rails

Install
-------

Add to your Gemfile:

    gem "mini_auth"

or install as a plugin

    $ cd RAILS_ROOT
    $ rails plugin install git://github.com/kuroda/mini_auth.git

Usage
-----

    class CreateUsers < ActiveRecord::Migration
      def change
        create_table :users do |t|
          t.string :name, :null => false
          t.string :password_digest, :null => true
    
          t.timestamps
        end
      end
    end
    
    class User < ActiveRecord::Base
      include MiniAuth
    end
    
    a = User.new(:name => "alice", :password => "hotyoga")
    
    a.save                              # => true
    a.password_digest                   # => "$2a$10$F5YbEd..."
    a.authenticate("hotyoga)            # => true
    
    a.update_attributes :name => "Alice"
    a.authenticate("hotyoga")           # => true
    
    b = User.new(:name => "bob")
    
    b.password = ""
    b.valid?                            # => false
    b.errors[:password]                 # => "can't be blank"

    b.password = nil
    b.valid?                            # => true
    b.save!
    b.password_digest                   # => nil
    b.authenticate(nil)                 # => false

    b.update_attributes :password_digest => 'dummy'
    b.password_digest                   # => nil (unchanged)

License
-------

`mini_auth` is distributed under the MIT license. ([MIT-LICENSE](https://github.com/kuroda/mini_auth/blob/master/MIT-LICENSE))

Copyright
---------

Copyright (c) 2011 Tsutomu Kuroda.
