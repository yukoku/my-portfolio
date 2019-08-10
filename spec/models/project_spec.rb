require 'rails_helper'

RSpec.describe Project, type: :model do
  it { is_expected.to validate_presence_of :name }

  it "is valid with name, description and due_on" do
    project = Project.create(
      name: "Test Project",
      description: "This is test project",
      due_on: 1.day.after
    )
    expect(project).to be_valid
  end

  it "is valid with due on today" do
    project = FactoryBot.create(:project, :due_today)
    expect(project).to be_valid
  end

  it "is valid with empty due" do
    project = FactoryBot.create(:project, due_on: '')
    expect(project).to be_valid
  end

  it "is invalid with due on past date" do
    project = FactoryBot.build(:project, :due_yesterday)
    project.valid?
    expect(project.errors[:due_on]).to include(I18n.t('errors.messages.on_or_after', restriction: Time.zone.today))
  end

  it "is invalid with name length over 25"do
    project = FactoryBot.build(:project, name: 'a' * 26)
    project.valid?
    expect(project.errors[:name]).to include(I18n.t("errors.messages.too_long", count: 25))
  end

end
