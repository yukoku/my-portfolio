class Users::InvitationsController < Devise::InvitationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  def new
    @invited_project = Project.find(params[:project_id])
    super
  end
protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:name])
  end

private

  # override
  def invite_resource
    invited_project = Project.find(params[:invited_project][:id])
    # Todo:invited_project.nil?のときの処理
    user = User.invite!({ email: params[:user][:email] }, current_user) do |u|
      u.skip_invitation = true
    end
    # ユーザー招待後に自動でプロジェクトに参加するため
    # メール送信前にプロジェクトメンバーに追加しておく
    project_invitation_token = encript_token(user.raw_invitation_token)
    user.project_users.create(project_id: invited_project.id, project_invitation_token: project_invitation_token)
    user.deliver_invitation
    return user
  end

  # override
  def accept_resource
    user = User.accept_invitation!(update_resource_params)
    project_invitation_token = encript_token(update_resource_params[:invitation_token])
    project_user = user.project_users.find_by(project_invitation_token: project_invitation_token)
    project_user.update(accepted_project_invitation: true)
    user
  end

  def encript_token(token)
    Digest::MD5.hexdigest(token)
  end

end
