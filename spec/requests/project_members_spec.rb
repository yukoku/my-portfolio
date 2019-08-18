
require 'rails_helper'

RSpec.describe "ProjectMembers", type: :request do
  def extract_confirmation_url(mail)
    body = mail.body.encoded
    body[/http[s:][^"]+/]
  end

  before do
    @owner = FactoryBot.create(:user)
    @owner.confirm
    sign_in @owner
  end

  context "as invited by a project owner" do
    let(:owned_project_relation) { @owner.project_members.where(owner: true).first }
    let(:unaccepted_invitation_user) {
      user = FactoryBot.create(:user)
      user.project_members.create(project_id: owned_project_relation.project_id)
      user }
    let(:member) {
      user = FactoryBot.create(:user)
      user.project_members.create(project_id: owned_project_relation.project_id,
                                  accepted_project_invitation: true)
      user }

    describe "Get #new" do
      it "responds successfully" do
        get new_project_member_path(project_id: owned_project_relation.project_id)
        expect(response).to have_http_status(200)
      end
    end

    describe "Post #create" do
      context "with valid attributes" do
        it "responds successfully" do
          user = FactoryBot.create(:user)
          project_member_attribute = FactoryBot.attributes_for(:project_member, user_id: user.id)
          expect {
            post project_members_path(project_id: owned_project_relation.project_id), params: { project_member: project_member_attribute }
          }.to change(ProjectMember.where(project_id: owned_project_relation.project_id), :count).by(1)
        end
      end
      context "with invalid attributes" do
        it "does not add a member" do
          user = FactoryBot.create(:user)
          project_member_attribute = FactoryBot.attributes_for(:project_member, user_id: nil)
          expect {
            post project_members_path(project_id: owned_project_relation.project_id), params: { project_member: project_member_attribute }
          }.to_not change(ProjectMember.where(project_id: owned_project_relation.project_id), :count)
        end
      end
    end

    # edit の正常系には認証トークンが必要なためfeaturesスペックでテストする
    describe "Get #edit" do
      context "with invalid token" do
        it "redirect to root url" do
          get edit_project_member_path(project_id: owned_project_relation.project_id, id: unaccepted_invitation_user.project_members.first.id)
          expect(response).to redirect_to(root_path)
        end
      end
    end

    describe "Patch #update" do
      context "with invalid token" do
        it "redirect to root url" do
          patch project_member_path(project_id: owned_project_relation.project_id, id: unaccepted_invitation_user.project_members.first.id)
          expect(response).to redirect_to(root_path)
        end
      end
    end

    describe "Delete #destroy" do
        it "delete a member relationship" do
          expect {
            delete project_member_path(project_id: owned_project_relation.project_id, id: member.project_members.first.id)
          }.to change(member.project_members, :count).by(-1)
        end
      end
    end

  context "invite already invited member" do
    let(:owned_project_relation) { @owner.project_members.where(owner: true).first }
    let(:member) {
      user = FactoryBot.create(:user)
      user.project_members.create(project_id: owned_project_relation.project_id,
                                  accepted_project_invitation: true)
      user }
    describe "Post #create" do
      context "with valid attributes" do
        it "does not create new membership" do
          project_member_attribute = FactoryBot.attributes_for(:project_member, user_id: member.id)
          expect {
            post project_members_path(project_id: owned_project_relation.project_id), params: { project_member: project_member_attribute }
          }.to_not change(ProjectMember.where(project_id: owned_project_relation.project_id), :count)
        end
      end
    end
  end
end