require 'rails_helper'

RSpec.describe Project, type: :model do
  it { is_expected.to validate_presence_of :name }

  it "is valid with name, description and due_on" do
    project = Project.create(
      name: "Test Project",
      description: "This is test project",
      due_on: 1.day.ago
    )
    expect(project).to be_valid
  end
end
