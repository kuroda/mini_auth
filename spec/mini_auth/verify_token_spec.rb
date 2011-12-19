require 'spec_helper'

describe "verify_token" do
  let(:user) do
    u = User.create!(:name => 'alice')
    u.update_token(:auto_login)
    u
  end
  
  it "should verify auto_login_token" do
    user.verify_token(:auto_login, user.auto_login_token).should be_true
  end
  
  it "should reject wrong token" do
    user.verify_token(:auto_login, 'z' * 32).should be_false
  end
end
