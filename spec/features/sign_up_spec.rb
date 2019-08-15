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

    within ".jumbotron" do
      click_link I18n.t("common_layout.header.sign_up")
    end
    form_label = "activerecord.attributes.user"
    fill_in I18n.t("#{form_label}.name"), with: user.name
    fill_in I18n.t("#{form_label}.email"), with: user.email
    fill_in I18n.t("#{form_label}.password"), with: user.password
    fill_in I18n.t("#{form_label}.password_confirmation"), with: user.password

    expect {
      click_button I18n.t("users.registrations.new.sign_up")
      expect(page).to have_content I18n.t("users.registrations.signed_up_but_unconfirmed")
    }.to change(ActionMailer::Base.deliveries, :count).by(1)

    mail = ActionMailer::Base.deliveries.last
    url = extract_confirmation_url(mail)
    visit url
    expect(page).to have_content I18n.t("users.confirmations.confirmed")

    # log in
    fill_in I18n.t("#{form_label}.email"), with: user.email
    fill_in I18n.t("#{form_label}.password"), with: user.password
    click_button I18n.t("users.sessions.new.sign_in")
    expect(page).to have_content I18n.t("users.sessions.signed_in")

    within ".jumbotron" do
      click_link I18n.t("users.sessions.new.sign_out")
    end
    expect(page).to have_content I18n.t("users.sessions.signed_out")
  end

end
