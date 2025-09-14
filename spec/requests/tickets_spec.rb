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
        expect(response).to redirect_to(project_ticket_path(@project, @project.tickets.last.id))
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
        file_path = Rails.root.to_s + '/spec/support/test_files/test_01.png'
        expect {
          @ticket.description += "test"
          File.open(file_path) { |f| @ticket.attached_files.attach(io: f, filename: "test.png", content_type: 'image/png')}
          patch project_ticket_path(@project, @ticket), params: { ticket: @ticket.attributes }
          @ticket.reload
        }.to change { @ticket.description }
        expect(response).to redirect_to(project_ticket_path(@project, @ticket))
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
    context "with attached files" do
      context "512KB size file" do
        it "success to update ticket" do
          file_path = Rails.root.to_s + '/spec/support/test_files/test_512KB.png'
          expect {
            File.open(file_path) { |f| @ticket.attached_files.attach(io: f, filename: "test.png", content_type: 'image/png')}
            patch project_ticket_path(@project, @ticket), params: { ticket: @ticket.attributes }
            @ticket.reload
          }.to change(@ticket.attached_files, :count).by(1)
          expect(response).to redirect_to(project_ticket_path(@project, @ticket))
        end
      end
      context "over 512KB size file" do
        it "fails to update ticket for file size validation" do
          file_path = Rails.root.to_s + '/spec/support/test_files/test_513KB.png'
          File.open(file_path) { |f| @ticket.attached_files.attach(io: f, filename: "test.png", content_type: 'image/png')}
          patch project_ticket_path(@project, @ticket), params: { ticket: @ticket.attributes }
          @ticket.reload
          expect(response.body.include?(I18n.t("errors.messages.file_too_large", file_size: "512Kbyte"))).to eq(true)
        end
      end
      context "too many files" do
        it "fails to update ticket for file count validation" do
          11.times do |n|
            file_path = Rails.root.to_s + "/spec/support/test_files/test_#{(n + 1).to_s.rjust(2, '0')}.png"
            File.open(file_path) { |f| @ticket.attached_files.attach(io: f, filename: "test.png", content_type: 'image/png')}
          end
          patch project_ticket_path(@project, @ticket), params: { ticket: @ticket.attributes }
          @ticket.reload
          expect(response.body.include?(I18n.t("errors.messages.file_too_many", file_count: 10))).to eq(true)
        end
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

  describe "DELETE #destroy_attached_file" do
    def setup_attached_file
      file_path = Rails.root.to_s + '/spec/support/test_files/test_01.png'
      File.open(file_path) { |f| @ticket.attached_files.attach(io: f, filename: "test.png", content_type: 'image/png')}
      @ticket.save
    end
    it "delete an attached file" do
      setup_attached_file
      attached_file_id = @ticket.attached_files.first.id
      expect {
        delete destroy_attached_file_project_ticket_path(@project, @ticket, attached_file_id: attached_file_id)
        @ticket.reload
      }.to change(@ticket.attached_files, :count).by(-1)
      expect(response).to redirect_to(project_ticket_url(@project, @ticket))
    end
  end
end
