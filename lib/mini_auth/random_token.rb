require "mini_auth/version"
require "bcrypt"

module MiniAuth
  module RandomToken
    extend ActiveSupport::Concern
    module ClassMethods
      def token(*names)
        names.each do |name|
          self.class_eval <<-METHOD, __FILE__, __LINE__ + 1
            def generate_#{name}_token
              send("#{name}_token=", SecureRandom.hex)
            end
          METHOD

          self.class_eval <<-METHOD, __FILE__, __LINE__ + 1
            def verify_#{name}_token(token)
              token && token == self.send("#{name}_token")
            end
          METHOD
        end
      end
    end
  end
end
