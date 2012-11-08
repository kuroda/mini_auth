require 'spec_helper'

describe "mass assignment security" do
  it "should not protect all columns by default" do
    u = User.create!(:name => 'alice', :password => 'hotyoga')
    u.name.should eq 'alice'
  end
end
