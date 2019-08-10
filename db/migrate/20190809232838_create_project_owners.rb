class CreateProjectOwners < ActiveRecord::Migration[5.2]
  def change
    remove_reference :projects, :owner, foreign_key: { to_table: :users }

    create_table :project_owners do |t|
      t.references :user, index: true, foreign_key: true
      t.references :project, index: true, foreign_key: true

      t.timestamps
    end
  end
end
