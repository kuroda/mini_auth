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
end
