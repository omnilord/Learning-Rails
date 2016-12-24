class User < ActiveRecord::Base
  devise :authy_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  has_many :friendships
  has_many :friends, through: :friendships

  attr_accessor :mfa # virtual field for sign-up form to allow redirecting to Authy setup

  def fullname
    name = "#{first_name} #{last_name}".strip
    name.empty? ? "My Profile" : name
  end
end
