require 'rails_helper'

RSpec.describe "Application", type: :request do
  context "as not authenticated user" do
    it "redirect to log in form " do
      get projects_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
