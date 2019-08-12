require 'rails_helper'

RSpec.describe TicketPriority, type: :model do
  describe "association" do
    describe "belongs_to" do
      it { is_expected.to belong_to(:project) }
    end
    describe "has_many" do
      it { is_expected.to have_many(:ticket) }
    end
  end
  it "is valid with ticket priority and project id" do
    project = FactoryBot.create(:project)
    ticket_priority = TicketPriority.create(priority: "my priority",
                                              project_id: project.id)
    expect(ticket_priority).to be_valid
  end

  it "is invalid with duplicate priority in a project" do
    ticket_priority = FactoryBot.create(:ticket_priority)
    duplicate_ticket_priority = FactoryBot.build(:ticket_priority,
                                                  project_id: ticket_priority.project_id)
    duplicate_ticket_priority.valid?
    expect(duplicate_ticket_priority.errors[:priority]).to include(I18n.t("errors.messages.taken"))
  end

  it "is invalid without priority" do
    ticket_priority = FactoryBot.build(:ticket_priority, priority: "")
    ticket_priority.valid?
    expect(ticket_priority.errors[:priority]).to include(I18n.t("errors.messages.blank"))
  end

  it "is invalid with over length ticket_priority" do
    ticket_priority = FactoryBot.build(:ticket_priority, priority: "a" * 21)
    ticket_priority.valid?
    expect(ticket_priority.errors[:priority]).to include(I18n.t("errors.messages.too_long", count: 20))
  end
end