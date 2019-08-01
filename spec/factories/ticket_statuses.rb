FactoryBot.define do
  factory :ticket_status do
    project
    status { "original status" }
  end
end