class CreateProjectMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :project_members do |t|
      t.integer :member_id
      t.integer :project_id

      t.timestamps
    end
    add_index :project_members, :member_id
    add_index :project_members, :project_id
    add_index :project_members, [:member_id, :project_id], unique: true
  end
end
