FactoryBot.define do
  factory :ticket_metadata, class: 'TicketMetadata' do
    association :project
    name { "MyString" }
  end
end
