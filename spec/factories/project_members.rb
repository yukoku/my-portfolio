FactoryBot.define do
  factory :project_member do
    user
    project
    accepted_project_invitation { true }
    owner { true }

    trait :not_accepted_invitation do
      accepted_project_invitation { false }
    end
  end
end
