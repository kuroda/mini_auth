require "mini_auth/version"
require "bcrypt"

module MiniAuth
  extend ActiveSupport::Concern
  
  included do
    attr_accessor :password, :changing_password, :old_password

    if respond_to?(:attributes_protected_by_default)
      def self.attributes_protected_by_default
        super + [ 'password_digest' ]
      end
    end
    
    validate do
      if changing_password?
        unless authenticate(old_password)
          errors.add(:old_password, :invalid)
        end
        
        if password.blank?
          errors.add(:password, :blank)
        end
      else
        if password && password.blank?
          errors.add(:password, :blank)
        end
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
  
  def changing_password?
    !!@changing_password
  end
end
