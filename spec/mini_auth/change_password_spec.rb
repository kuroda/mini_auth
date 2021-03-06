require 'spec_helper'

describe "change_password" do
  let(:user) do
    u = User.new(:name => 'alice', :password => 'password')
    u.setting_password = true
    u.save!
    u.changing_password = true
    u
  end

  it "should change password" do
    user.update_attributes(:current_password => 'password', :new_password => 'banana')
    
    user.authenticate('banana').should be_true
  end

  it "should unset changing_password flag afterwards" do
    user.update_attributes(:current_password => 'password', :new_password => 'banana')
    
    user.changing_password.should be_false
  end
  
  it "should reject wrong current password" do
    user.assign_attributes(:current_password => 'lemon', :new_password => 'banana')
    
    user.should_not be_valid
    user.should have(1).error_on(:current_password)
    user.errors[:current_password].first.should == "is invalid"
  end
  
  it "should reject blank string as new password" do
    user.assign_attributes(:current_password => 'password', :new_password => '')
    
    user.should_not be_valid
    user.should have(1).error_on(:new_password)
    user.errors[:new_password].first.should == "can't be blank"
  end
end
