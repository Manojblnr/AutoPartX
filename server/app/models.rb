require 'sequel'
require 'bcrypt'

db_file = Pathname.new(__dir__).join('../database/AutoPartX.sqlite').to_s

DB = Sequel.sqlite db_file

Sequel::Model.plugin	:timestamps,
						:create    => :created_at,
						:update    => :updated_at,
						:force    => true,
						:update_on_create => true

class User < Sequel::Model(DB[:users])

    def self.register data
        raise "Username is required" if data[:username].nil?
        raise "MobileNumber is required" if data[:mobile].nil?
        raise "Email is required" if data[:email].nil?
        # raise "Password is required" if data[:password].nil?

        exist_user = self.find(username: data[:username])
        
        user_obj = {
            username: data[:username],
            email: data[:email],
            mobile: data[:mobile],
            password_digest: BCrypt::Password.create(data[:password])
        }

        if exist_user
            exist_user.update(user_obj)
        else
            new_user = User.new(user_obj)
            new_user.save
        end
        
        user_obj
    end
end

