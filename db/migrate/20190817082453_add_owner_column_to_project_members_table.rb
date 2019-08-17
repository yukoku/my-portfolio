class AddOwnerColumnToProjectMembersTable < ActiveRecord::Migration[5.2]
  def change
    add_column :project_members, :owner, :boolean, default: false
  end
end
