class Article < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3, maximum: 255 }
  validates :body, presence: true, length: { minimum: 10, maximum: 1024 }
  validates :user_id, presence: true

  before_validation do
    if self.association_loaded?(:user) #&& self.user.changed?
      if self.user.changed?
        if self.user.save != false
          self.user_id = self.user.id
        elsif self.user.errors.full_messages.empty?
          self.errors.add :user, "unknown error saving changed user"
        else
          self.user.errors.full_messages.each do |msg|
            self.errors.add :user, msg
          end
        end
      end
    end
  end
end
