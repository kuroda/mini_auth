require 'spec_helper'

describe "use_token" do
  let(:user) do
    User.create!(:name => 'alice')
  end
  
  it "should update auto_login_token" do
    expect {
      user.update_auto_login_token
    }.to change { user.auto_login_token }
    
    user.auto_login_token.should_not be_nil
    user.auto_login_token.length.should == 32
  end
  
  it "should update mail_confirmation_token" do
    expect {
      user.update_mail_confirmation_token
    }.to change { user.mail_confirmation_token }
    
    user.mail_confirmation_token.should_not be_nil
    user.mail_confirmation_token.length.should == 32
  end
  
  it "should verify auto_login_token" do
    user.update_auto_login_token
    
    user.verify_auto_login_token(user.auto_login_token).should be_true
  end
end
