require 'spec_helper'

describe "change_password" do
  let(:user) do
    u = User.create!(:name => 'alice', :password => 'password')
    u.changing_password = true
    u
  end
  
  it "should change password" do
    user.update_attributes(:old_password => 'password', :password => 'banana')
    
    user.authenticate('banana').should be_true
  end
  
  it "should reject wrong old password" do
    user.assign_attributes(:old_password => 'lemon', :password => 'banana')
    
    user.should_not be_valid
    user.should have(1).error_on(:old_password)
    user.errors[:old_password].first.should == "is invalid"
  end
  
  it "should reject blank string as new password" do
    user.assign_attributes(:old_password => 'password', :password => '')
    
    user.should_not be_valid
    user.should have(1).error_on(:password)
    user.errors[:password].first.should == "can't be blank"
  end
end
