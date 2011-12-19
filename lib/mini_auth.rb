require "mini_auth/version"
require "bcrypt"

module MiniAuth
  extend ActiveSupport::Concern
  
  included do
    attr_accessor :password, :changing_password,
      :current_password, :new_password

    if respond_to?(:attributes_protected_by_default)
      def self.attributes_protected_by_default
        super + [ 'password_digest' ]
      end
    end
    
    validate do
      if changing_password?
        unless authenticate(current_password)
          errors.add(:current_password, :invalid)
        end
        
        if new_password.blank?
          errors.add(:new_password, :blank)
        end
      else
        if password && password.blank?
          errors.add(:password, :blank)
        end
      end
    end
    
    after_validation do
      if changing_password?
        self.password_digest = BCrypt::Password.create(new_password)
      elsif password
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
    !!changing_password
  end
end
