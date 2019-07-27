require 'rails_helper'

RSpec.feature "UserInvitation", type: :feature do
  background do
    ActionMailer::Base.deliveries.clear
  end

  def extract_confirmation_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end

  scenario "invite user to ownered project" do
    user = FactoryBot.create(:user)
    ownered_project = user.projects.first
    user.confirm
    sign_in user

    visit project_path(ownered_project)
    click_link I18n.t("project.project_member.create")

    invite_user = FactoryBot.build(:user)
    form_label = "activerecord.attributes.user"
    inputs = { email: invite_user.email }
    fill_in I18n.t("#{form_label}.email"), with: invite_user.email

    expect {
      click_button I18n.t("devise.invitations.new.submit_button")
      expect(page).to have_content I18n.t("devise.invitations.send_instructions", email: invite_user.email)
    }.to change(ActionMailer::Base.deliveries, :count).by(1)

    mail = ActionMailer::Base.deliveries.last
    url = extract_confirmation_url(mail.html_part)
    visit url

    fill_in I18n.t("#{form_label}.name"), with: invite_user.name
    fill_in I18n.t("#{form_label}.password"), with: invite_user.password
    fill_in I18n.t("#{form_label}.password_confirmation"), with: invite_user.password
    click_button I18n.t("devise.invitations.edit.submit_button")
    expect(page).to have_content I18n.t("devise.invitations.updated")
    expect(page).to have_content ownered_project.name
  end
end
