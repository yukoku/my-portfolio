class Ticket < ApplicationRecord
  belongs_to :project
  belongs_to :assignee, class_name: "User"
  belongs_to :creator, class_name: "User"
  belongs_to :ticket_attribute
  belongs_to :ticket_status
  belongs_to :ticket_priority
  validates_date :due_on, on_or_after: lambda { Time.zone.today }, allow_blank: true
end
