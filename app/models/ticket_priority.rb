class TicketPriority < ApplicationRecord
  belongs_to :project
  has_one :ticket
end
