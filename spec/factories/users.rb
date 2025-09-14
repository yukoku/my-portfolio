FactoryBot.define do
  factory :user, aliases: [:member, :creator, :assignee] do
    sequence(:name) { |n| "name#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password" }
    admin { false }

    trait :admin_user do
      admin { true }
    end

    after(:create) do |user|
      project = create(:project)
      create(:project_member, user: user, project: project)
      ticket = create(:ticket, assignee: user, creator: user, project: project)
      create(:comment, user_id: user.id, ticket_id: ticket.id)
    end
  end
end
