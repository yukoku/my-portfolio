class TicketStatus < ApplicationRecord
  belongs_to :project
  has_many :ticket
  validates :status, presence: true, length: { maximum: 20 }, uniqueness: { scope: :project_id }

  DEFAULT_STATUS = [
    "ticket.status.todo",
    "ticket.status.doing",
    "ticket.status.done"
  ]

  def self.default_setting(project_id)
    DEFAULT_STATUS.each do |status|
      create(project_id: project_id, status: I18n.t(status))
    end
  end
end