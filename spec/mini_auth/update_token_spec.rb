require 'spec_helper'

describe "update_token" do
  let(:user) do
    User.create!(:name => 'alice')
  end
  
  it "should set auto_login_token" do
    expect {
      user.update_token(:auto_login)
    }.to change { user.auto_login_token }
    
    user.auto_login_token.should_not be_nil
    user.auto_login_token.length.should == 32
  end
end
