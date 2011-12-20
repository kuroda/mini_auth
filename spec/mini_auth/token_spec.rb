require 'spec_helper'

describe "MiniAuth.token" do
  let(:user) do
    User.create!(:name => 'alice')
  end
  
  it "should generate auto_login_token" do
    expect {
      user.generate_auto_login_token
    }.to change { user.auto_login_token }
    
    user.auto_login_token.should_not be_nil
    user.auto_login_token.length.should == 32
  end
  
  it "should generate mail_confirmation_token" do
    expect {
      user.generate_mail_confirmation_token
    }.to change { user.mail_confirmation_token }
    
    user.mail_confirmation_token.should_not be_nil
    user.mail_confirmation_token.length.should == 32
  end
  
  it "should verify auto_login_token" do
    user.generate_auto_login_token
    
    user.verify_auto_login_token(user.auto_login_token).should be_true
  end
end
