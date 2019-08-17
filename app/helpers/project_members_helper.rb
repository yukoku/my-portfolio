module ProjectMembersHelper
  def accept_project_invitation_url(project, project_member, **parameters)
    project_member_url(project, project_member) + '?' + parameters.to_query
  end
end
