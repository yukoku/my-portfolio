FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "MyString#{n}" }
    description { "MyText" }
    due_on { 1.day.after }

    trait :due_today do
      due_on { Time.zone.now }
    end

    trait :due_yesterday do
      due_on { 1.day.ago }
    end
  end

  factory :owner, class: User do
    name { "name" }
  end
end
