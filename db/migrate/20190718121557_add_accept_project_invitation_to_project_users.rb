class AddAcceptProjectInvitationToProjectUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :project_users, :accepted_project_invitation, :boolean, default: false
  end
end
