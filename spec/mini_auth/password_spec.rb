require 'spec_helper'

describe "password" do
  it "should accept nil password" do
    u = User.new(:name => 'alice', :password => nil)
    u.should be_valid
  end
  
  it "should reject blank password" do
    u = User.new(:name => 'alice', :password => '')
    u.should_not be_valid
    u.should have(1).error_on(:password)
    u.errors[:password].first.should == "can't be blank"
  end
  
  it "should reject nil password for Administrator" do
    a = Administrator.new(:name => 'alice', :password => nil)
    a.should_not be_valid
    a.should have(1).error_on(:password)
    a.errors[:password].first.should == "can't be blank"
  end
  
  it "should validate password_confirmation for Administrator" do
    a = Administrator.new(:name => 'alice', :password => 'apple', :password_confirmation => 'almond')
    a.should_not be_valid
    a.should have(1).error_on(:password)
    a.errors[:password].first.should == "doesn't match confirmation"
  end
end
