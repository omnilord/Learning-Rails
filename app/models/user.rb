class User < ActiveRecord::Base

  # Defining all the privilege-related values as constants
  PRIV_LVL_DESCS = ['Banned', 'User', 'Senior User', 'Mod', 'Senior Mod', 'Administrator'].freeze
  PRIV_LVL_STYLES = ['danger', 'success', 'info', 'info', 'info', 'warning'].freeze
  PRIV_ADMIN = 5
  PRIV_SR_MOD = 4
  PRIV_MOD = 3
  PRIV_SR_USER = 2
  PRIV_USER = 1
  PRIV_NONE = 0

  attr_accessor :PRIV_LVL_DESCS, :PRIV_LVL_STYLES
  attr_accessor :PRIV_ADMIN, :PRIV_SR_MOD, :PRIV_MOD, :PRIV_SR_USER, :PRIV_USER, :PRIV_NONE

  has_many :comments, dependent: :destroy
  has_many :articles, dependent: :destroy

  validates_confirmation_of :password

  validates :username, presence: true, uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 25 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates_format_of :email, with: /\A[^@]+@[^@]+\z/
  has_secure_password

  def email=(val)
    write_attribute :email, val.downcase
  end

  def privilege_level
    User::PRIV_LVL_DESCS[self.privilege]
  end

  def privilege_style(target)
    User::PRIV_LVL_STYLES[self.privilege]
  end
end
