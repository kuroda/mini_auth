require "mini_auth/version"
require "bcrypt"

module MiniAuth
  extend ActiveSupport::Concern
  
  included do
    attr_accessor :password

    if respond_to?(:attributes_protected_by_default)
      def self.attributes_protected_by_default
        super + [ 'password_digest' ]
      end
    end
    
    validate do
      if password && password.blank?
        errors.add(:password, :blank)
      end
    end
    
    before_save do
      if password
        self.password_digest = BCrypt::Password.create(password)
        self.password = nil
      end
    end
  end
  
  def authenticate(password)
    if password_digest && BCrypt::Password.new(password_digest) == password
      self
    else
      false
    end
  end
end
