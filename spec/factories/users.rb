FactoryBot.define do
  factory :user, aliases: [:member, :creator, :assignee] do
    sequence(:name) { |n| "name#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password" }

    after(:create) do |user|
      create(:project_member, user: user, project: create(:project, owner_id: user.id))
      create(:project_member, :not_accepted_invitation, user: user, project: create(:project, owner_id: user.id))
    end
  end
end
