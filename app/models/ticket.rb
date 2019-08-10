class Ticket < ApplicationRecord
  belongs_to :project
  belongs_to :assignee, class_name: "User", optional: true
  belongs_to :creator, class_name: "User", optional: true
  belongs_to :ticket_attribute, optional: true
  belongs_to :ticket_status, optional: true
  belongs_to :ticket_priority, optional: true
  validates_date :due_on, on_or_after: lambda { Time.zone.today }, allow_blank: true
end
