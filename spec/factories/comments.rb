FactoryBot.define do
  factory :comment do
    content { "MyText" }
    ticket
    user
  end
end
