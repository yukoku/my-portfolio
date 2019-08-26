require 'rails_helper'

RSpec.feature "StaticPages", type: :system do
  scenario "link to static pages" do
    visit root_path
    click_link "Home"
    expect(page).to have_content "Team Works"

    click_link "About"
    expect(page).to have_content "About"

    click_link "Team Works"
    expect(page).to have_content "Team Works"
  end
end
