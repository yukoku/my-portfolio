require 'rails_helper'

RSpec.describe TicketAttribute, type: :model do
  describe "association" do
    describe "belongs_to" do
      it { is_expected.to belong_to(:project)}
    end
    describe "has_many" do
      it { is_expected.to have_many(:ticket)}
    end
  end

  it "is valid with ticket attribute and project id" do
    project = FactoryBot.create(:project)
    ticket_attribute = TicketAttribute.create(ticket_attribute: "my attribute",
                                              project_id: project.id)
    expect(ticket_attribute).to be_valid
  end

  it "is invalid with duplicate attribute in a project" do
    ticket_attribute = FactoryBot.create(:ticket_attribute)
    duplicate_ticket_attribute = FactoryBot.build(:ticket_attribute,
                                                  project_id: ticket_attribute.project_id)
    duplicate_ticket_attribute.valid?
    expect(duplicate_ticket_attribute.errors[:ticket_attribute]).to include(I18n.t("errors.messages.taken"))
  end

  it "is invalid without ticket_attribute" do
    ticket_attribute = FactoryBot.build(:ticket_attribute, ticket_attribute: "")
    ticket_attribute.valid?
    expect(ticket_attribute.errors[:ticket_attribute]).to include(I18n.t("errors.messages.blank"))
  end

  it "is invalid with over length ticket_attribute" do
    ticket_attribute = FactoryBot.build(:ticket_attribute, ticket_attribute: "a" * 21)
    ticket_attribute.valid?
    expect(ticket_attribute.errors[:ticket_attribute]).to include(I18n.t("errors.messages.too_long", count: 20))
  end
end