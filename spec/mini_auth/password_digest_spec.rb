require 'spec_helper'

describe "password_digest" do
  it "should be protected against mass assignment" do
    u = User.create!(:name => 'alice', :password => 'hotyoga')
    d = u.password_digest.to_s
    u.update_attributes :password_digest => 'dummy'
    u.password_digest.to_s.should == d
  end
  
  it "should be protected against mass assignment also for Administrator" do
    a = Administrator.create!(:name => 'alice', :password => 'hotyoga', :password_confirmation => 'hotyoga')
    d = a.password_digest.to_s
    a.update_attributes :password_digest => 'dummy'
    a.password_digest.to_s.should == d
  end
end
