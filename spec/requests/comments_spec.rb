require 'rails_helper'

RSpec.describe "Comments", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @user.confirm
    sign_in @user
    @project = @user.projects.first
    @ticket = @project.tickets.first
    @comment = @user.comments.first
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "responds successfully" do
        comment_attributes = FactoryBot.attributes_for(:comment)
        expect {
          post project_ticket_comments_path(@project, @ticket), params: { comment: comment_attributes }
        }.to change(@ticket.comments, :count).by(1)
        expect(response).to redirect_to(project_ticket_path(@project, @ticket))
      end
    end
    context "with invalid attributes" do
      it "does not create comment" do
        comment_attributes = FactoryBot.attributes_for(:comment, content: "")
        expect {
          post project_ticket_comments_path(@project, @ticket), params: { comment: comment_attributes }
        }.to_not change(@ticket.comments, :count)
      end
    end
    context "with invalid path" do
      it "redirect to root path when invalid ticket path" do
        comment_attributes = FactoryBot.attributes_for(:comment)
        another_ticket = FactoryBot.create(:ticket)
        expect {
          post project_ticket_comments_path(@project, another_ticket), params: { comment: comment_attributes }
        }.to_not change(@user.comments, :count)
        expect(response).to redirect_to(root_path)
      end
      it "redirect to root path when invalid project path" do
        comment_attributes = FactoryBot.attributes_for(:comment)
        another_project = FactoryBot.create(:project)
        expect {
          post project_ticket_comments_path(another_project, @ticket), params: { comment: comment_attributes }
        }.to_not change(@ticket.comments, :count)
        expect(response).to redirect_to(root_path)
      end
    end
  end
  describe "DELETE #destroy" do
    context "by a project member" do
      it "delete a comment" do
        expect {
          delete project_ticket_comment_path(@project, @ticket, @comment)
        }.to change(@ticket.comments, :count).by(-1)
        expect(response).to redirect_to(project_ticket_path(@project, @ticket))
      end
    end
    context "by not a project member" do
      it "does not delete a comment" do
        another_user = FactoryBot.create(:user)
        another_user.confirm
        sign_in another_user
        expect {
          delete project_ticket_comment_path(@project, @ticket, @comment)
        }.to_not change(@ticket.comments, :count)
        expect(response).to redirect_to(root_path)
      end
    end
    context "with another project" do
      it "does not delete a comment" do
        another_project = FactoryBot.create(:project)
        expect {
          delete project_ticket_comment_path(another_project, @ticket, @comment)
        }.to_not change(@ticket.comments, :count)
        expect(response).to redirect_to(root_path)
      end
    end
    context "with another ticket" do
      it "does not delete a comment" do
        another_ticket = FactoryBot.create(:ticket)
        expect {
          delete project_ticket_comment_path(@project, another_ticket, @comment)
        }.to_not change(@ticket.comments, :count)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
