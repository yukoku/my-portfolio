FactoryBot.define do
  factory :ticket do
    title { "MyString" }
    description { "MyText" }
    due_on { 1.day.after }
    association :assignee, factory: :user
    creator
    association :project, factory: :project, name: "test"
  end
end
