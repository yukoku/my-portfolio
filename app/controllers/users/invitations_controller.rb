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
    @inviting_project = Project.find(params[:invited_project][:id])
    # Todo:invited_project.nil?のときの処理
    user = User.find_by(email: params[:user][:email])
    # Todo: 既存ユーザーのプロジェクト招待
#    if user
#      project_invitation_token = new_token
#      user.project_users.create(project_id: @inviting_project.id, project_invitation_token: project_invitation_token)
#      return user
#    end

    user = User.invite!({ email: params[:user][:email] }, current_user) do |u|
      u.skip_invitation = true
    end
    return user if !user.errors.empty?
    # ユーザー招待後に自動でプロジェクトに参加するため
    # メール送信前に関係テーブルに追加しておく
    project_invitation_token = encript_token(user.raw_invitation_token)
    user.project_users.create(project_id: @inviting_project.id, project_invitation_token: project_invitation_token)
    user.deliver_invitation
    user
  end

  # override
  def after_invite_path_for(inviter)
    project_path(@inviting_project)
  end

  # override
  def accept_resource
    user = User.accept_invitation!(update_resource_params)
    project_invitation_token = encript_token(update_resource_params[:invitation_token])
    project_user = user.project_users.find_by(project_invitation_token: project_invitation_token)
    project_user.update(accepted_project_invitation: true)
    @invited_project = Project.find(project_user.project_id)
    user
  end

  # override
  def after_accept_path_for(invitee)
    project_path(@invited_project)
  end

  def encript_token(token)
    Digest::MD5.hexdigest(token)
  end

  def new_token
    SecureRandom.urlsafe_base64
  end

end
