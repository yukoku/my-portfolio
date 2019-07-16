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
    project = FactoryBot.create(:project, due_on: Date.current)
    expect(project).to be_valid
  end

  it "is valid with empty due on" do
    project = FactoryBot.create(:project, due_on: '')
    expect(project).to be_valid
  end

  it "is invalid with due on past date" do
    project = FactoryBot.build(:project, due_on: 1.day.ago)
    project.valid?
    expect(project.errors[:due_on]).to include(I18n.t('errors.messages.on_or_after', :restriction => Date.current))
  end

end
