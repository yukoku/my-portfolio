class RemoveTablesRelatedToTicket < ActiveRecord::Migration[6.1]
  def change
    remove_reference :tickets, :ticket_attribute, foreign_key: true
    remove_reference :tickets, :ticket_status, foreign_key: true
    remove_reference :tickets, :ticket_priority, foreign_key: true

    drop_table :ticket_attributes
    drop_table :ticket_statuses
    drop_table :ticket_priorities
  end
end
