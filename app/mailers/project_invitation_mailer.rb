class ProjectInvitationMailer < ApplicationMailer
  helper ProjectMembersHelper
  default from: 'noreply@secure-reef-34800.herokuapp.com'

  def invitation_email
    @invitee = params[:invitee]
    @inviter = params[:inviter]
    @project = params[:project]
    @project_member = params[:project_member]
    @raw_token = params[:token]
    mail(to: @invitee.email, subject: I18n.t("project.project_member.invitation.mail.subject", user: @inviter.name, project: @project.name))
  end
end
