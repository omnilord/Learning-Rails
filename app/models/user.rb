class User < ActiveRecord::Base
  has_many :comments
  has_many :articles

  validates_confirmation_of :password

  validates :username, presence: true, uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 25 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :email, with: /\A[^@]+@[^@]+\z/
  has_secure_password

  before_save do
    self.email = email.downcase
  end
end
