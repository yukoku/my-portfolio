FactoryBot.define do
  factory :user, aliases: [:member] do
    sequence(:name) { |n| "name#{n}" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "password" }

    after(:create) do |user|
      create(:project_user, user: user, project: create(:project, owner_id: user.id))
      create(:project_user, :not_accepted_invitation, user: user, project: create(:project, owner_id: user.id))
    end
  end
end
