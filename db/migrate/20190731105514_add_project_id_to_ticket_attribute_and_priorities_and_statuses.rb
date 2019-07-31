class AddProjectIdToTicketAttributeAndPrioritiesAndStatuses < ActiveRecord::Migration[5.2]
  def change
    add_reference :ticket_attributes, :project, foreign_key: true
    add_reference :ticket_statuses, :project, foreign_key: true
    add_reference :ticket_priorities, :project, foreign_key: true
  end
end
