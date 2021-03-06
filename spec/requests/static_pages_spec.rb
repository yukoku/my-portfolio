require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "unauthenticated guest user" do
    it "responds successfully from home" do
      get root_path
      expect(response).to have_http_status(200)
    end

    it "responds successfully from about" do
      get '/about'
      expect(response).to have_http_status(200)
    end
  end
end
