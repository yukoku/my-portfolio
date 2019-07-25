require 'rails_helper'

RSpec.feature "SignUp", type: :feature do
  background do
    ActionMailer::Base.deliveries.clear
  end

  def extract_confirmation_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end

  scenario "sign up" do
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
    }.to change(ActionMailer::Base.deliveries, :count).by(1)

    mail = ActionMailer::Base.deliveries.last
    url = extract_confirmation_url(mail)
    visit url
    expect(page).to have_content I18n.t("devise.confirmations.confirmed")

    # log in
    fill_in I18n.t("#{form_label}.email"), with: user.email
    fill_in I18n.t("#{form_label}.password"), with: user.password
    click_button "Log in"
    expect(page).to have_content I18n.t("devise.sessions.signed_in")

    within ".sign-in" do
      click_link I18n.t("devise.sessions.new.sign_out")
    end
    expect(page).to have_content I18n.t("devise.sessions.signed_out")
  end

end
