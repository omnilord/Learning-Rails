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

  def portfolio_summary
    value = 0
    shares = 0
    stocks = 0
    watches = 0

    UserStock.where('user_id = ?', self.id).each do |tracking|
      if tracking.owned > 0
        value += tracking.owned * tracking.stock.last_price
        shares += tracking.owned
        stocks += 1
      else
        watches += 1
      end
    end

    { value: value, shares: shares, stocks: stocks, watches: watches }
  end
end
