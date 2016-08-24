class User < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  has_many :articles, dependent: :destroy

  validates_confirmation_of :password

  validates :username, presence: true, uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 25 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :email, with: /\A[^@]+@[^@]+\z/
  has_secure_password

  before_save do
    self.email = email.downcase
  end

  def privilege_level
    ['Banned', 'User', 'Senior User', 'Mod', 'Senior Mod', 'Administrator'][self.privilege]
  end

  def privilege_style(target)
    ['danger', 'success', 'info', 'info', 'info', 'warning'][self.privilege]
  end
end
