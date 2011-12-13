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
    a.authenticate("wrong")             # => false

Remarks
-------

Password can't be blank.

    b = User.new(:name => "bob")
    
    b.password = ""
    b.valid?                            # => false
    b.errors[:password]                 # => "can't be blank"

But, password can be nil.

    b.password = nil
    b.valid?                            # => true

You can save a user whose `password_digest` is nil.

    b.save!
    b.password_digest                   # => nil

Such a user can't get authenticated.

    b.authenticate(nil)                 # => false

The `password_digest` field is protected against mass assignment.

    b.update_attributes :password_digest => 'dummy'
    b.password_digest                   # => nil (unchanged)

The `password_confirmation` field is not created automatically. If you need it, add it for yourself.

    class User < ActiveRecord::Base
      include MiniAuth
      
      attr_accessor :password_confirmation
      validates :password, :confirmation => true
    end

License
-------

`mini_auth` is distributed under the MIT license. ([MIT-LICENSE](https://github.com/kuroda/mini_auth/blob/master/MIT-LICENSE))

Copyright
---------

Copyright (c) 2011 Tsutomu Kuroda.
