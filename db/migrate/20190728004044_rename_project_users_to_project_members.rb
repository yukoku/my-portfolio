class RenameProjectUsersToProjectMembers < ActiveRecord::Migration[5.2]
  def change
    rename_table :project_users, :project_members
  end
end
