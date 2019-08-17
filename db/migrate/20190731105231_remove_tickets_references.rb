class RemoveTicketsReferences < ActiveRecord::Migration[5.2]
  def change
    remove_column :project_members, :has_sent_message
  end
end
