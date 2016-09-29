class Article < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3, maximum: 255 }
  validates :body, presence: true, length: { minimum: 10, maximum: 1024 }
  validates :user_id, presence: true

  before_validation do
    if self.association_loaded?(:user)
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

  def tags=(list = [])
    if list.nil?
      list = []
    else
      list.uniq!
      list.sort!
    end

    # Monkey patching the tags list since ActiveRecord does not default to Set
    # Does an implicit uniq and sort so that looping ops do not get repeated
    class <<list
      def <<(s)
        self.replace(self.take_while { |el| (el <=> s) < 1 } | [s] | self) unless self.include? s
        self
      end
    end

    write_attribute(:tags, list) unless list.eql?(self[:tags])
  end
end
