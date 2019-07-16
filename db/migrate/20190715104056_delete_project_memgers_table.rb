class DeleteProjectMemgersTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :project_members
  end
end
