require "mini_auth/version"

module MiniAuth
  extend ActiveSupport::Concern
  
  included do
    attr_accessor :password
  end
  
  def authenticate(password)
    true
  end
end
