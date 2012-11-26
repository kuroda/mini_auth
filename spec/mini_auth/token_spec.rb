require 'spec_helper'

describe "MiniAuth::Token.token" do
  let(:user) { User.create!(:name => 'alice') }
  let(:email) { Email.create!(:address => 'alice@example.com') }
  
  it "should generate auto_login_token" do
    expect {
      user.generate_auto_login_token
    }.to change { user.auto_login_token }
    
    user.auto_login_token.should_not be_nil
    user.auto_login_token.length.should == 32
  end
  
  it "should generate confirmation_token" do
    expect {
      email.generate_confirmation_token
    }.to change { email.confirmation_token }
    
    email.confirmation_token.should_not be_nil
    email.confirmation_token.length.should == 32
  end
  
  it "should verify auto_login_token" do
    user.generate_auto_login_token
    
    user.verify_auto_login_token(user.auto_login_token).should be_true
  end
  
  it "should reject wrong token" do
    user.verify_auto_login_token('z' * 32).should be_false
  end
end
