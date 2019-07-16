FactoryBot.define do
  factory :project do
    name { "MyString" }
    description { "MyText" }
    due_on { 1.day.after }

    trait :due_today do
      due_on { Date.current.in_time_zone }
    end

    trait :due_yesterday do
      due_on { 1.day.ago }
    end
  end

  factory :owner, class: User do
    name { "name" }
  end
end
