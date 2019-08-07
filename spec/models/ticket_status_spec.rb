require 'rails_helper'

RSpec.describe TicketStatus, type: :model do
  it "is valid with ticket priority and project id" do
    project = FactoryBot.create(:project)
    ticket_status = TicketStatus.create(status: "my status",
                                              project_id: project.id)
    expect(ticket_status).to be_valid
  end

  it "is invalid with duplicate status in a project" do
    ticket_status = FactoryBot.create(:ticket_status)
    duplicate_ticket_status = FactoryBot.build(:ticket_status,
                                                  project_id: ticket_status.project_id)
    duplicate_ticket_status.valid?
    expect(duplicate_ticket_status.errors[:status]).to include(I18n.t("errors.messages.taken"))
  end

  it "is invalid without status" do
    ticket_status = FactoryBot.build(:ticket_status, status: "")
    ticket_status.valid?
    expect(ticket_status.errors[:status]).to include(I18n.t("errors.messages.blank"))
  end

  it "is invalid with over length ticket_status" do
    ticket_status = FactoryBot.build(:ticket_status, status: "a" * 21)
    ticket_status.valid?
    expect(ticket_status.errors[:status]).to include(I18n.t("errors.messages.too_long", count: 20))
  end
end