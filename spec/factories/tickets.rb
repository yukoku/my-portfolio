FactoryBot.define do
  factory :ticket do
    title { "MyString" }
    description { "MyText" }
    due_on { 1.day.after }
    assignee
    creator
    project
    ticket_attribute
    ticket_status
    ticket_priority
  end
end
