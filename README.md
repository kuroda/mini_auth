mini_auth
=========

A replacement for `has_secure_password` of ActiveModel with some enhancements


Install
-------

Add to your Gemfile:

    gem "mini_auth"

or install as a plugin

    $ cd RAILS_ROOT
    $ rails plugin install git://github.com/kuroda/mini_auth.git


Requirements
------------

* Ruby on Rails 3.1 or higher


Synopsis
--------

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
      
      attr_accessible :name
    end
    
    a = User.new(:name => "alice", :password => "hotyoga")
    a.setting_password => true
    
    a.save                              # => true
    a.password_digest                   # => "$2a$10$F5YbEd..."
    
    x = User.find_by_name("alice")
    x.authenticate("wrong")             # => false
    x.authenticate("hotyoga)            # => x
    
    x.attributes = { :current_password => 'hotyoga', :new_password => 'almond' }
    x.changing_password = true
    x.save
    
    y = User.find_by_name("alice")
    y.authenticate("hotyoga)            # => false
    y.authenticate("almond")            # => y


Usage
-----

### Migration

To use `mini_auth`, you must add the `password_digest` column to the relevant table.

    class CreateUsers < ActiveRecord::Migration
      def change
        create_table :users do |t|
          t.string :name, :null => false
          t.string :password_digest, :null => true
    
          t.timestamps
        end
      end
    end

The raw (unencrypted) password will never be saved on the database. Only its hash value
is recorded on the `password_digest` column.


### Default behavior

The module `MiniAuth` introduces two basic attributes: `setting_password` and `changing_password`

When neither of them is set to `true`, you can NOT set or change the user's `password_digest`.

    a = User.find_by_name("alice")
    a.password = 'foobar'
    a.password_digest_changed?          # => false
    a.valid?                            # => true


### Setting password

When the user's `setting_password` attribute is set to `true`, its password can
be set without knowing the current password.

    a = User.find_by_name("alice")
    a.setting_password => true
    a.update_attributes(:password => 'p@ssword')
    a.authenticate("p@ssword")          # => a

Password can't be blank.

    b = User.new(:name => "bob", :password => "")
    b.setting_password => true
    b.valid?                            # => false
    b.errors[:password]                 # => "can't be blank"

Password can't be nil.

    b = User.new(:name => "bob", :password => nil)
    b.setting_password => true
    b.valid?                            # => false
    b.errors[:password]                 # => "can't be blank"

Password should be given.

    b = User.new(:name => "bob")
    b.setting_password => true
    b.valid?                            # => false
    b.errors[:password]                 # => "can't be blank"


### Changing password

When the user's `changing_password` attribute is set to `true`, its password can
NOT be set without knowing the current password. You should provide `current_password`
and `new_password` attributes to change its password.

    a = User.find_by_name("alice")
    a.changing_password => true
    a.update_attributes(:current_password => 'p@ssword', :new_password => 'opensesame')
    a.authenticate("opensesame")        # => a

If the `current_password` is wrong, the validation fails.

    a = User.find_by_name("alice")
    a.changing_password => true
    a.attributes = { :current_password => 'pumpkin', :new_password => '0000' }
    a.valid?                            # => false
    a.errors[:current_password]         # => [ "is invalid" ]

When both of the `setting_password` and the `changing_password` are set to `true`,
only the latter is effective.


### A user who has no password

You can save a user whose `password_digest` is nil.

    c = User.new(:name => "carol")
    c.save!
    c.password_digest                   # => nil

Such a user can't get authenticated, but can exist as a temporary account or placeholder.

    c.authenticate(nil)                 # => false

If you don't want such a user to be created, add a validation to your class.

    class User < ActiveRecord::Base
      include MiniAuth
      
      validates :password_digest, :presence => true
    end


### Confirmation of password

The `password_confirmation` and `new_password_confirmation` attributes are created automatically.

    c = User.find_by_name("carol")
    c.setting_password = true
    c.attributes = { :password => 'snowman', :password_confirmation => 'iceman' }
    c.valid?                            # => false
    c.errors[:password]                 # => [ "doesn't match confirmation" ]
    
    a = User.find_by_name("alice")
    a.changing_password => true
    a.attributes = { :current_password => 'opensesame',
      :new_password => 'snowman', :new_password_confirmation => 'iceman' }
    a.valid?                            # => false
    a.errors[:new_password]             # => [ "doesn't match confirmation" ]

You don't have to use them, however.

    c = User.find_by_name("carol")
    c.setting_password = true
    c.attributes = { :password => 'snowman' }
    c.valid?                            # => true


### Mass assignment security

The `password_digest` column is protected against _mass assignment_.

    c.update_attributes(:password_digest => 'dummy')
    c.password_digest                   # => nil (unchanged)

Similarly, the `setting_password` and `changing_password` attributes are protected.

    c.attributes = { :setting_password => true, :password => '0000' }
    c.setting_password?                 # => false

A class that includes `Miniauth` is forced to adopt the _whitelist-principle_ regarding the mass assignment protection.
That is, you have to enumerate the names of attributes that can be set via a hash by the `attr_accessible` method.

    class User < ActiveRecord::Base
      include MiniAuth
      
      attr_accessible :name, :address, :phone
    end

Note that the attributes `password`, `password_confirmation`, `current_password`, `new_password`, and
`new_password_confirmation` are included in the whitelist by default.

If your class has a _role_ such as :admin, you should enumerate the accessible attributes as follows:

    class User < ActiveRecord::Base
      include MiniAuth
      
      attr_accessible :name, :address, :phone
      attr_accessible *(accessible_attributes(:default) + [ :is_admin ]), :as => :admin
    end

For more information about mass assignment security, please refer to the 
[Mass Assignment](http://guides.rubyonrails.org/security.html#mass-assignment) section of Rails Guides.


### Random token

`MiniAuth` module provides an easy way to generate a random token and verify it. 

The class method `token` takes a list of names and defines "generate\_#{name}\_token" and "verify\_#{name}\_token" methods dynamically.

    class User < ActiveRecord::Base
      include MiniAuth
      
      attr_accessible :name, :address, :phone
      token :auto_login, :mail_confirmation
    end

By calling `generate_auto_login_token`, you can generate a random hex string of 32 letters and set it to the `auto_login_token` column.

    d = User.new(:name => "david")
    d.generate_auto_login_token
    d.auto_login_token                 # => "8d21d3830a3ef2aafe8a7c0388493883"

Call `verify_auto_login_token` to verify it. For example, 

    d.verify_auto_login_token(params[:token])

returns `true` if `params[:token]` equals to the generated token. Otherwise it returns `false`.


License
-------

`mini_auth` is distributed under the MIT license. ([MIT-LICENSE](https://github.com/kuroda/mini_auth/blob/master/MIT-LICENSE))


Copyright
---------

Copyright (c) 2011 Tsutomu Kuroda <t-kuroda@oiax.jp>.
