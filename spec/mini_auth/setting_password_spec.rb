require 'spec_helper'

describe "setting_password" do
  it "should set password" do
    u = User.new(:name => 'alice', :password => 'hotyoga')
    u.setting_password = true
    u.should be_valid
    u.save!
    
    v = User.find_by_name('alice')
    v.authenticate('hotyoga').should be_true
  end

  it "should set password even if the user is saved without validation" do
    u = User.new(:name => 'alice', :password => 'hotyoga')
    u.setting_password = true
    u.save(:validate => false)

    v = User.find_by_name('alice')
    v.authenticate('hotyoga').should be_true
  end

  it "should update password" do
    u = User.create!(:name => 'alice')
    u.setting_password = true
    u.update_attributes(:password => 'hotyoga')
    u.authenticate('hotyoga').should be_true
  end

  it "should unset setting_password flag afterwards" do
    u = User.create!(:name => 'alice')
    u.setting_password = true
    u.update_attributes(:password => 'hotyoga')
    u.setting_password.should be_false
  end

  it "should reject blank password" do
    u = User.new(:name => 'alice', :password => '')
    u.setting_password = true
    u.should_not be_valid
    u.should have(1).error_on(:password)
    u.errors[:password].first.should == "can't be blank"
  end

  it "should reject nil password" do
    u = User.new(:name => 'alice', :password => nil)
    u.setting_password = true
    u.should_not be_valid
    u.should have(1).error_on(:password)
    u.errors[:password].first.should == "can't be blank"
  end
  
  it "should set user's password without confirmation" do
    u = User.new(:name => 'alice', :password => 'apple')
    u.setting_password = true
    u.should be_valid
    u.save!
    u.authenticate('apple').should be_true
  end
  
  it "should validate password_confirmation if it is given" do
    u = User.new(:name => 'alice', :password => 'apple', :password_confirmation => 'almond')
    u.setting_password = true
    u.should_not be_valid
    u.should have(1).error_on(:password)
    u.errors[:password].first.should == "doesn't match confirmation"
  end
end
