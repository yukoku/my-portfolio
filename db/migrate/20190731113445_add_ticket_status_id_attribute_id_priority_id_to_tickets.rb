class AddTicketStatusIdAttributeIdPriorityIdToTickets < ActiveRecord::Migration[5.2]
  def change
    add_reference :tickets, :ticket_attribute, foreign_key: true
    add_reference :tickets, :ticket_status, foreign_key: true
    add_reference :tickets, :ticket_priority, foreign_key: true
  end
end
