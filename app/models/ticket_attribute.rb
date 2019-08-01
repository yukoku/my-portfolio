class TicketAttribute < ApplicationRecord
  belongs_to :project
  has_many :ticket
  validates :ticket_attribute, presence: true, length: { maximum: 20 }, uniqueness: { scope: :project_id }


  DEFAULT_ATTRIBUTE = [
    "ticket.attribute.feature",
    "ticket.attribute.bug",
    "ticket.attribute.support",
    "ticket.attribute.environment",
    "ticket.attribute.document"
  ]

  def self.default_setting(project_id)
    DEFAULT_ATTRIBUTE.each do |attribute|
      create(project_id: project_id, ticket_attribute: I18n.t(attribute))
    end
  end
end
