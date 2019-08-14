class AddMissingIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :project_owners, [:project_id, :user_id]
    add_index :users, [:invited_by_id, :invited_by_type]
  end
end