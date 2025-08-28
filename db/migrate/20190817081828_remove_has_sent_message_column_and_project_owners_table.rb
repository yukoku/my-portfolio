class RemoveHasSentMessageColumnAndProjectOwnersTable < ActiveRecord::Migration[5.2]
  def change
    # TODO: なぜか動かないので一旦コメントアウト
    # remove_column :project_members, :has_sent_message, :boolean
    drop_table :project_owners
  end
end
