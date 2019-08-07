require 'rails_helper'

RSpec.describe "Projects", type: :request do
  context "as a project member" do
    before do
      @user = FactoryBot.create(:user)
      @user.confirm
      sign_in @user
      @project = @user.projects.first
    end

    describe "Get #index" do
      it "responds successfully" do
        get projects_path
        expect(response).to have_http_status(200)
      end
    end

    describe "Get #new" do
      it "responds successfully" do
        get new_project_path
        expect(response).to have_http_status(200)
      end
    end

    describe "Get #edit" do
      it "responds successfully" do
        get edit_project_path(@project)
        expect(response).to have_http_status(200)
      end
    end

    describe "Get #show" do
      it "responds successfully" do
        get project_path(@project)
        expect(response).to have_http_status(200)
      end
    end

    describe "Post #create" do
      context "with valid attributes" do
        it "add a project" do
          project_attribute = FactoryBot.attributes_for(:project)
          expect {
            post projects_path, params: { project: project_attribute }
          }.to change(@user.projects, :count).by(1)
        end
      end
      context "with invalid attributes" do
        it "does not add a project" do
          project = FactoryBot.attributes_for(:project, :invalid)
          expect {
            post projects_path, params: { project: project }
          }.to_not change(@user.projects, :count)
        end
      end
    end

    describe "Patch #update" do
      context "with valid attributes" do
        it "update a project" do
          expect {
            @project.description = "another description"
            patch project_path(@project), params: { project: @project.attributes }
            @project.reload
          }.to change { @project.description }
          expect(response).to have_http_status(302)
        end
      end
      context "with invalid attributes" do
        it "does not update a project" do
          expect {
            @project.due_on = 1.day.ago
            patch project_path(@project), params: { project: @project.attributes }
            @project.reload
          }.to_not change { @project.due_on }
        end
      end
    end
    describe "Delete #destroy" do
      it "delete a project" do
        expect {
          delete project_path(@project)
        }.to change(@user.projects, :count).by(-1)
      end
    end
  end

  context "as not project member" do
    before do
      @user = FactoryBot.create(:user)
      @user.confirm
      sign_in @user
      @project = FactoryBot.create(:project)
    end

    describe "Get #edit" do
      it "redirect to projects path" do
        get edit_project_path(@project)
        expect(response).to redirect_to(projects_path)
      end
    end
    describe "Get #show" do
      it "redirect to projects path" do
        get project_path(@project)
        expect(response).to redirect_to(projects_path)
      end
    end
    describe "Patch #update" do
      context "with valid attributes" do
        it "does not update project and redirect to projects path" do
          expect {
            @project.description = "another description"
            patch project_path(@project), params: { project: @project.attributes }
            @project.reload
          }.to_not change { @project.description }
          expect(response).to redirect_to(projects_path)
        end
      end
    end
    describe "Delete #destroy" do
      it "does not delete project and redirect to projects path" do
        expect {
          delete project_path(@project)
          @project.reload
        }.to_not change{ @project }
        expect(response).to redirect_to(projects_path)
      end
    end
  end
end
