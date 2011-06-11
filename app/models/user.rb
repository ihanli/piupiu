class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :validatable, :confirmable, :timeoutable

  attr_accessible :email, :password, :password_confirmation, :country, :ido
end
