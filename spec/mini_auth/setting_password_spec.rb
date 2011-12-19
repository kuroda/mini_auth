require 'spec_helper'

describe "setting_password" do
  it "should set password" do
    u = User.new(:name => 'alice', :password => 'hotyoga')
    u.setting_password = true
    u.should be_valid
    u.save!
    u.authenticate('hotyoga').should be_true
  end
  
  it "should update password" do
    u = User.create!(:name => 'alice')
    u.setting_password = true
    u.update_attributes(:password => 'hotyoga')
    u.authenticate('hotyoga').should be_true
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
