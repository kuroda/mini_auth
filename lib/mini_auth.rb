require "mini_auth/version"
require "bcrypt"

module MiniAuth
  extend ActiveSupport::Concern
  
  BASIC_ATTRIBUTES = [
    :password, :password_confirmation,
    :current_password,
    :new_password, :new_password_confirmation
  ]
  
  included do
    attr_accessor :changing_password, :setting_password
    attr_accessor *BASIC_ATTRIBUTES
    attr_accessible *BASIC_ATTRIBUTES
    
    validates :password, :new_password, :confirmation => true

    if respond_to?(:attributes_protected_by_default)
      def self.attributes_protected_by_default
        super + [ 'password_digest', 'changing_password', 'setting_password' ]
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
      elsif setting_password?
        if password.blank?
          errors.add(:password, :blank)
        end
      end
    end
    
    after_validation do
      if changing_password?
        self.password_digest = BCrypt::Password.create(new_password)
      elsif setting_password?
        self.password_digest = BCrypt::Password.create(password)
      end
    end
    
    after_save do
      self.password = nil
    end
  end
  
  def authenticate(raw_password)
    if password_digest && BCrypt::Password.new(password_digest) == raw_password
      self
    else
      false
    end
  end

  def update_token(name)
    self.send("#{name}_token=", SecureRandom.hex)
  end

  def verify_token(name, token)
    token && token == self.send("#{name}_token")
  end

  def changing_password?
    !!changing_password
  end
  
  def setting_password?
    !!setting_password
  end
end
