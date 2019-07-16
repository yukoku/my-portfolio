class RemoveUserFromProjects < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :projects, :users
    remove_index :projects, :user_id
    remove_reference :projects, :user
  end
end
