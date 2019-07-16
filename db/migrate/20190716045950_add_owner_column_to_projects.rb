class AddOwnerColumnToProjects < ActiveRecord::Migration[5.2]
  def change
    add_reference :projects, :owner, foreign_key: { to_table: :users }
  end
end
