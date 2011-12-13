# encoding: utf-8

require 'spec_helper'

describe "authenticate" do
  it "should authenticate with a valid password" do
    u = User.new(:name => 'alice', :password => 'hotyoga')
    u.save!
    
    u.authenticate('hotyoga').should be_true
  end
  
  it "should not authenticate with a wrong password" do
    u = User.new(:name => 'alice', :password => 'hotyoga')
    u.save!
    
    u.authenticate('wrong').should be_false
  end
end
