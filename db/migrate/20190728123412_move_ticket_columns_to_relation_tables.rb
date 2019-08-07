class MoveTicketColumnsToRelationTables < ActiveRecord::Migration[5.2]
  def change
    remove_column :tickets, :ticket_attribute, :string
    remove_column :tickets, :status, :string
    remove_column :tickets, :priority, :string

    create_table :ticket_attributes do |t|
      t.string :ticket_attribute
    end

    create_table :ticket_statuses do |t|
      t.string :status
    end

    create_table :ticket_priorities do |t|
      t.string :priority
    end

    add_reference :tickets, :ticket_attribute, foreign_key: true
    add_reference :tickets, :ticket_status, foreign_key: true
    add_reference :tickets, :ticket_priority, foreign_key: true
  end
end
