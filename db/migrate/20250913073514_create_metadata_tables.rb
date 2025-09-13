class CreateMetadataTables < ActiveRecord::Migration[6.1]
  def change
    create_table :ticket_metadata do |t|
      t.references :project, foreign_key: true, null: false
      t.string :name, null: false

      t.timestamps
    end

    create_table :ticket_metadata_values do |t|
      t.references :ticket_metadata, foreign_key: true, null: false
      t.references :ticket, foreign_key: true, null: false
      t.string :value

      t.timestamps
    end
  end
end

