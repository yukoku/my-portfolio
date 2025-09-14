class TicketMetadata < ApplicationRecord
  belongs_to :project
  has_many :ticket_metadata_values, dependent: :destroy

  DEFAULT_METADATA = [
    "activerecord.attributes.ticket.attribute",
    "activerecord.attributes.ticket.status",
    "activerecord.attributes.ticket.priority"
  ]

  def self.default_setting(project_id)
    DEFAULT_METADATA.each do |meta|
      create(project_id: project_id, name: I18n.t(meta))
    end
  end
end
