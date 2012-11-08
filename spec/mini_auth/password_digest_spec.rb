require 'spec_helper'

describe "password_digest" do
  it "should be protected against mass assignment by default" do
    u = User.create!(:name => 'alice', :password => 'hotyoga')
    d = u.password_digest.to_s
    u.update_attributes :password_digest => 'dummy'
    u.password_digest.to_s.should == d
  end

  it "should be protected against mass assignment when using white list protection" do
    m = Member.create!(:name => 'alice', :password => 'hotyoga')
    d = m.password_digest.to_s
    m.update_attributes :password_digest => 'dummy'
    m.password_digest.to_s.should == d
  end

  it "should be protected against mass assignment when using black list protection" do
    a = Administrator.create!(:name => 'alice', :password => 'hotyoga')
    d = a.password_digest.to_s
    a.update_attributes :password_digest => 'dummy'
    a.password_digest.to_s.should == d
  end
end
