class AddHasSentMessageToProjectUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :project_users, :has_sent_message, :boolean, default: false
  end
end
