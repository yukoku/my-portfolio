require 'rails_helper'

RSpec.describe "Users", type: :request do
  context "as an admin user" do
    before do
      @admin = FactoryBot.create(:user, admin: true)
      @admin.confirm
      sign_in @admin
    end

    describe "Get #index" do
      it "responds successfully" do
        get users_path
        expect(response).to have_http_status(200)
      end
    end
    describe "Get #show" do
      it "responds successfully" do
        get user_path(@admin)
        expect(response).to have_http_status(200)
      end
    end
    describe "Delete #destroy" do
      it "delete a user" do
        user = FactoryBot.create(:user)
        expect {
          delete user_path(user)
        }.to change(User, :count).by(-1)
      end
    end
  end

  context "as not admin user" do
    before do
      @user = FactoryBot.create(:user, admin: false)
      @user.confirm
      sign_in @user
    end

    describe "Delete #destroy" do
      it "does not delete a user" do
        other_user = FactoryBot.create(:user)
        expect {
          delete user_path(other_user)
        }.to_not change(User, :count)
        expect(response).to redirect_to(root_url)
      end
    end
  end
end