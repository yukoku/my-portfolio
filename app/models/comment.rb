class Comment < ApplicationRecord
  belongs_to :ticket
  belongs_to :user
  validates :content, presence: true, length: { maximum: 255 }
  validates :user_id, presence: true
  validates :ticket_id, presence: true
end
