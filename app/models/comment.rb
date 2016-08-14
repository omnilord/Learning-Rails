class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :article

  validates :user_id, presence: true
  validates :body, length: { minimum: 3, maximum: 511 }
end
