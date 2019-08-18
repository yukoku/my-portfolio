require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe "make full page title" do
    BASE_TITLE = 'Team Works'
    it "return base title if title is empty" do
      expect(helper.full_title("")).to eq(BASE_TITLE)
    end

    it "concat base title if title is not empty" do
      PAGE_TITLE = "Title"
      expect(helper.full_title(PAGE_TITLE)).to eq(PAGE_TITLE + " | " +  BASE_TITLE)
    end
  end
end
