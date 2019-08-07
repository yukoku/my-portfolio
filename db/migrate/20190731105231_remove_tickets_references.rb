class RemoveTicketsReferences < ActiveRecord::Migration[5.2]
  def change
    remove_reference :tickets, :ticket_attribute, foreign_key: true
    remove_reference :tickets, :ticket_status, foreign_key: true
    remove_reference :tickets, :ticket_priority, foreign_key: true
  end
end
