class AddProjectInvitationTokenToProjectUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :project_users, :project_invitation_token, :string
    add_index :project_users, :project_invitation_token, unique: true
  end
end
