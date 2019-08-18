class ProjectMembersController < ApplicationController
  before_action :project_owner, only: %i[new create destroy]
  before_action :confirm_token, only: %i[edit update]
  before_action :inviting_member, only: %i[edit update]
  before_action :already_accepted, only: %i[update]

  def new
    @users = User.where.not(confirmed_at: nil)
    @project_member = ProjectMember.new
    @project = Project.find_by(id: params[:project_id])
  end

  def create
    @project_member = ProjectMember.new(project_member_params)
    @project_member[:project_id] = params[:project_id]
    raw_token = new_token
    @project_member[:project_invitation_token] = encript_token(raw_token)
    if @project_member.save
      @user = User.find_by(id: @project_member.user_id)
      ProjectInvitationMailer.with(invitee: @user,
                                   inviter: current_user,
                                   project: @project,
                                   project_member: @project_member,
                                   token: raw_token).invitation_email.deliver_later
    flash[:success] = I18n.t("project.project_member.invitation.flash.invited", user: @user.name)
    redirect_to project_path(@project)
    else
      @users = User.where.not(confirmed_at: nil)
      render 'new'
    end
  end

  def edit
    @project_member = ProjectMember.find(params[:id])
    @project = Project.find(@project_member.project_id)
    @token = params[:invitation_token]
  end

  def update
    @project_member = ProjectMember.find(params[:id])
    @project_member.update!(accepted_project_invitation: true, project_invitation_token: nil)
    flash[:success] = I18n.t("project.project_member.invitation.flash.success", project: @project_member.project.name)
    redirect_to project_path(id: @project_member.project_id)
  end

  def destroy
    ProjectMember.find(params[:id]).destroy
    @project = Project.find(params[:project_id])
    flash[:success] = I18n.t("project.project_member.invitation.flash.deleted")
    redirect_to project_path(@project)
  end

private
  def project_member_params
    params.require(:project_member).permit(:user_id)
  end

  def project_owner
    @project = Project.find(params[:project_id])
    redirect_to(root_url) unless @project&.project_members.where(user_id: current_user.id).first&.owner || current_user.admin?
  end

  def encript_token(token)
    Digest::MD5.hexdigest(token.to_s)
  end

  def new_token
    SecureRandom.urlsafe_base64
  end

  def confirm_token
    @project_member = ProjectMember.find(params[:id])
    unless @project_member.project_invitation_token == encript_token(params[:invitation_token])
      flash[:danger] = I18n.t("project.project_member.invitation.flash.invalid_token")
      redirect_to root_url
    end
  end

  def inviting_member
    @project_member = ProjectMember.find(params[:id])
    unless @project_member.user_id == current_user.id
      flash[:danger] = I18n.t("project.project_member.invitation.flash.invalid_user")
      redirect_to root_url
    end
  end

  def already_accepted
    @project_member = ProjectMember.find(params[:id])
    if @project_member.accepted_project_invitation
      flash[:info] = I18n.t("project.project_member.invitation.flash.already_accepted")
      redirect_to root_url
    end
  end
end
