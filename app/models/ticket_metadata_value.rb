class TicketMetadataValue < ApplicationRecord
  belongs_to :ticket_metadata
  belongs_to :ticket

  def self.default_setting(project_id)
    raise NotImplementedError
  end
end
