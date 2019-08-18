require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  context "as a test_user" do
    before do
      @test_user = FactoryBot.create(:user, name: "test_user")
      @test_user.confirm
      sign_in @test_user
    end

    describe "Patch #update" do
      it "redirect to root path" do
        user_attributes = FactoryBot.attributes_for(:user, name: "new_test_user")
        patch user_registration_path(@test_user), params: { user: user_attributes }
        expect(response).to redirect_to(root_url)
      end

    end
    describe "delete #destroy" do
      it "redirect to root path" do
        delete user_registration_path(@test_user)
        expect(response).to redirect_to(root_url)
      end
    end
  end
end