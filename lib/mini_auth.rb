require "mini_auth/version"
require "bcrypt"

module MiniAuth
  extend ActiveSupport::Concern
  
  included do
    attr_accessor :password
    
    validate do
      if password && password.blank?
        errors.add(:password, :blank)
      end
    end
    
    before_save do
      if password
        self.password_digest = BCrypt::Password.create(password)
      end
    end
  end
  
  def authenticate(password)
    password_digest && BCrypt::Password.new(password_digest) == password
  end
end
