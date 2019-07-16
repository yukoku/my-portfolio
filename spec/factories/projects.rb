FactoryBot.define do
  factory :project do
    name { "MyString" }
    description { "MyText" }
    due_on { 1.day.after }
  end
end
