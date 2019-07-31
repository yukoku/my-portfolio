class TicketAttribute < ApplicationRecord
  belongs_to :project
  has_one :ticket
end
