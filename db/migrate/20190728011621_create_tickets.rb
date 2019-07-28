class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.references :project, foreign_key: true
      t.references :creator, foreign_key: { to_table: :users }
      t.references :assignee, foreign_key: { to_table: :users }
      t.string :title
      t.string :attribute
      t.string :status
      t.string :priority
      t.text :description
      t.date :due_on

      t.timestamps
    end
  end
end
