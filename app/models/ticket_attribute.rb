class TicketAttribute < ApplicationRecord
  belongs_to :project
  has_many :ticket
end
