class TicketPriority < ApplicationRecord
  belongs_to :project
  has_many :ticket
  validates :priority, presence: true, length: { maximum: 20 }, uniqueness: { scope: :project_id }

  DEFAULT_PRIORITY = [
    "ticket.priority.very_high",
    "ticket.priority.high",
    "ticket.priority.normal",
    "ticket.priority.low",
    "ticket.priority.very_low"
  ]

  def self.default_setting(project_id)
    DEFAULT_PRIORITY.each do |priority|
      create(project_id: project_id, priority: I18n.t(priority))
    end
  end
end
