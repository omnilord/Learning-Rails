class User < ActiveRecord::Base
  devise :authy_authenticatable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_stocks
  has_many :stocks, through: :user_stocks

  has_many :friendships
  has_many :friends, through: :friendships

  attr_accessor :mfa # virtual field for sign-up form to allow redirecting to Authy setup

  class << self
    def search(search)
      search.strip!
      search.downcase!
      User.none if search.blank?

      (matches('email', search) + matches('first_name', search) + matches('last_name', search)).uniq
    end

    def matches(field, search)
      where("lower(#{field}) LIKE ?", "%#{search}%")
    end
  end

  def fullname
    name = "#{first_name} #{last_name}".strip
    name.empty? ? "My Profile" : name
  end

  def friend?(user)
    Friendship.exists? user: self, friend: user
  end

  def friendship_summary(current_user)
    {
      friend: {
        user_id: self.id,
        fullname: self.fullname,
        email: self.email,
        is_friend: current_user.friend?(self),
        has_friend: self.friend?(current_user)
      },
      portfolio: self.portfolio_summary,
      stocks: self.user_stocks.map do |tracking|
        { stock: tracking.stock, track: tracking }
      end
    }
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
