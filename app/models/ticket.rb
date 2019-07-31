class Ticket < ApplicationRecord
  belongs_to :project
  belongs_to :assignee, class_name: "User"
  belongs_to :creator, class_name: "User"
  belongs_to :ticket_attribute
  belongs_to :ticket_status
  belongs_to :ticket_priority
end
