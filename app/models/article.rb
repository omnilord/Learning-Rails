class Article < ActiveRecord::Base
  validates :title, presence: true, length: { minimum: 3, maximum: 255 }
  validates :body, presence: true, length: { minimum: 10, maximum: 1024 }
end
