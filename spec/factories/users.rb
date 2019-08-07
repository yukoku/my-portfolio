FactoryBot.define do
  factory :user, aliases: [:member, :creator, :assignee] do
    sequence(:name) { |n| "name#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password" }

    after(:create) do |user|
      project = create(:project, owner_id: user.id)
      create(:project_member, user: user, project: project)
      create(:project_member, :not_accepted_invitation, user: user, project: project)
      create(:ticket, assignee: user, creator: user, project: project,
                      ticket_attribute: project.ticket_attributes.first,
                      ticket_priority: project.ticket_priorities.first,
                      ticket_status: project.ticket_statuses.first)
    end
  end
end
