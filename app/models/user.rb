class User < ActiveRecord::Base
  has_many :comments
  has_many :articles

  validates :username, presence: true, uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 25 }
  validates :email, presence: true, uniqueness: { case_sensitive: false}
  validates_format_of :email, with: /\A[^@]+@[^@]+\z/

  before_save do
    self.email = email.downcase
  end
end
