class RenameAttributeColumnToTicketAttribute < ActiveRecord::Migration[5.2]
  def change
    # rename attribute column for ActiveRecord method name collision
    rename_column :tickets, :attribute, :ticket_attribute
  end
end
