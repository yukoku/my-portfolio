require 'rails_helper'

RSpec.describe ProjectMember, type: :model do
  describe "association" do
    describe "belongs_to" do
      it { is_expected.to belong_to(:project) }
      it { is_expected.to belong_to(:user) }
    end
  end

  let(:project) { FactoryBot.create(:project) }
  let(:user) { FactoryBot.create(:user) }
  it "is valide with project_id, user_id, accepted_project_invitation, owner" do
    project_member = ProjectMember.new(
      project_id: project.id,
      user_id: user.id,
      accepted_project_invitation: true,
      owner: true)
    project_member.valid?
    expect(project_member).to be_valid
  end

  it "is invalid with same user in a project" do
    project_member = FactoryBot.create(:project_member, project_id: project.id, user_id: user.id)
    duplicate_project_member = ProjectMember.new(
      project_id: project.id,
      user_id: user.id)

      duplicate_project_member.valid?
      expect(duplicate_project_member.errors[:user_id]).to include(I18n.t("errors.messages.taken"))
  end
end
