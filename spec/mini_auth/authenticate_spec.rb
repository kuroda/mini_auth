# encoding: utf-8

require 'spec_helper'

describe "authenticate" do
  it "User.save!" do
    u = User.new(:name => 'alice')
    u.save!
  end
end
