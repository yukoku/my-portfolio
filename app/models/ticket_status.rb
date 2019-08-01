class TicketStatus < ApplicationRecord
  belongs_to :project
  has_many :ticket
end