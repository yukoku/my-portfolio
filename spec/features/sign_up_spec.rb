require 'rails_helper'

RSpec.feature "SignUp", type: :feature do
  scenario "sign up and sign out" do
    user = FactoryBot.build(:user)
    visit root_path

    within ".sign-in" do
      click_link "ユーザー登録"
    end
    form_label = "activerecord.attributes.user"
    fill_in I18n.t("#{form_label}.name"), with: user.name
    fill_in I18n.t("#{form_label}.email"), with: user.email
    fill_in I18n.t("#{form_label}.password"), with: user.password
    fill_in I18n.t("#{form_label}.password_confirmation"), with: user.password

    expect {
      click_button "Sign up"
      expect(page).to have_content I18n.t("devise.registrations.signed_up_but_unconfirmed")
    }.to change(User, :count).by(1)
  end
end
