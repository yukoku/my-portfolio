class Users::DeviseInviteMailer < Devise::Mailer
  def invitation_instructions(record, token, opts={})
    @invited_project = Project.find(opts[:invited_project_id])
    super
  end
end