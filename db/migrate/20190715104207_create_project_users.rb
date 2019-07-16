class CreateProjectUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :project_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :project, index: true, foreign_key: true

      t.timestamps
    end
  end
end
