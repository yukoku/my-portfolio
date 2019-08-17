crumb :root do
  link "Home", root_path
end

crumb :users do
  link "Users", users_path
end

crumb :projects do
  link "Projects", projects_path
end

crumb :user_invitation do
  link "Invitation", new_user_invitation_path
end

crumb :user do |user|
  link user.name || "New user", user
  parent :users
end

crumb :project do |project|
  link project.name || "New project", project
  parent :projects
end

crumb :project_ticket do |project, ticket|
  link ticket.title || "New ticket", project_ticket_path(project, ticket)
  parent :project, project
end

crumb :project_member do |project|
  link "Invitation", new_project_member_path
  parent :project, project
end

crumb :user_tickets do |user|
   link "Tickets", tickets_path(user.id)
   parent :user, user
end
