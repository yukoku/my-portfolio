require 'rails_helper'

RSpec.describe "Tickets", type: :request do
  before do
    @user = FactoryBot.create(:user)
    @user.confirm
    sign_in @user
    @project = @user.projects.first
    @another_project = FactoryBot.create(:project)
    @ticket = @project.tickets.first
  end

  def set_attributes(ticket_attribute)
    ticket_attribute[:ticket_attribute_id] = @project.ticket_attributes.first.id
    ticket_attribute[:ticket_status_id] = @project.ticket_statuses.second.id
    ticket_attribute[:ticket_priority_id] = @project.ticket_priorities.last.id
    ticket_attribute[:assignee_id] = @user.id
    ticket_attribute[:creator_id] = @user.id
    ticket_attribute[:project_id] = @project.id
  end

  describe "GET #index" do
    it "responds successfully" do
      get tickets_path(@project)
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    context "by a project member" do
      it "responds successfully" do
        get project_ticket_path(@project, @ticket)
        expect(response).to have_http_status(200)
      end
    end

    context "by not a project member" do
      it "redirect to root path" do
        get project_ticket_path(@another_project, @ticket)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #new" do
    it "responds successfully" do
      get new_project_ticket_path(@project)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "add a ticket" do
        ticket_attribute = FactoryBot.attributes_for(:ticket)
        set_attributes(ticket_attribute)
        expect {
          post project_tickets_path(@project), params: { ticket: ticket_attribute }
        }.to change(@project.tickets, :count).by(1)
        expect(response).to redirect_to(project_path(@project))
      end
    end

    context "with invalid attributes" do
      it "fails to add a ticket" do
        ticket_attribute = FactoryBot.attributes_for(:ticket)
        set_attributes(ticket_attribute)
        ticket_attribute[:due_on] = 1.day.ago
        expect {
          post project_tickets_path(@project), params: { ticket: ticket_attribute }
        }.to_not change(@project.tickets, :count)
      end
    end
  end

  describe "GET #edit" do
    it "responds successfully" do
      get edit_project_ticket_path(@project, @ticket)
      expect(response).to have_http_status(200)
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "success to update ticket" do
        expect {
          @ticket.description += "test"
          patch project_ticket_path(@project, @ticket), params: { ticket: @ticket.attributes }
          @ticket.reload
        }.to change { @ticket.description }
        expect(response).to redirect_to(project_path(@project))
      end
    end
    context "with invalid attributes" do
      it "fails to update ticket" do
        expect {
          @ticket.due_on = 1.day.ago
          patch project_ticket_path(@project, @ticket), params: { ticket: @ticket.attributes }
          @ticket.reload
        }.to_not change { @ticket.due_on }
      end
    end
    context "with another project" do
      it "does not update ticket" do
        project = FactoryBot.create(:project)
        expect {
          @project.due_on = 2.day.after
          patch project_ticket_path(project, @ticket), params: { ticket: @ticket.attributes }
          @ticket.reload
        }.to_not change { @ticket }
      end
    end
  end

  describe "DELETE #destroy" do
    context "by a project member" do
      it "delete a ticket" do
        expect {
          delete project_ticket_path(@project, @ticket)
        }.to change(@project.tickets, :count).by(-1)
      end
    end

    context "by not a project member" do
      it "does not delete a ticket" do
        sign_out @user
        user = FactoryBot.create(:user)
        user.confirm
        sign_in user
        expect {
          delete project_ticket_path(@project, @ticket)
        }.to_not change(@project.tickets, :count)
        expect(response).to redirect_to(root_path)
      end
    end

    context "with another project" do
      it "does not delete a ticket" do
        expect {
          delete project_ticket_path(@another_project, @ticket)
        }.to_not change(@project.tickets, :count)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
