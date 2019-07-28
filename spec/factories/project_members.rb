FactoryBot.define do
  factory :project_member do
    user
    project
    accepted_project_invitation { true }
    has_sent_message { true }

    trait :not_yet_sent_message do
      has_sent_message { false }
    end

    trait :not_accepted_invitation do
      accepted_project_invitation { false }
      has_sent_message { false }
    end
  end
end
