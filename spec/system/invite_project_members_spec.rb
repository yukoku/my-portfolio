require 'rails_helper'

RSpec.feature "InviteProjectMembers", type: :system do
  background do
    ActionMailer::Base.deliveries.clear
  end

  def extract_confirmation_url(mail)
    body = mail.body.encoded
    body[/http[s:][^"]+/]
  end

  before do
    @user = FactoryBot.create(:user)
    @project = @user.projects.first
    @user.confirm
    sign_in @user
    @new_member = FactoryBot.create(:user)
    @new_member.confirm
    @member = FactoryBot.create(:user)
    @member.confirm
    @member.project_members.create(project_id: @project.id, accepted_project_invitation: true)
  end

  def invite_new_member
    visit project_path(@project)
    click_link I18n.t("project.header.new_member")

    select @new_member.name, from: "project_member[user_id]"

    expect {
      click_button I18n.t("devise.invitations.new.header")
      expect(page).to have_content I18n.t("project.project_member.invitation.flash.invited", user: @new_member.name)
    }.to change(ProjectMember.where(project_id: @project.id), :count).by(1)
  end

  scenario "invite new member and confirm"do
    invite_new_member

    sign_out @user
    mail = ActionMailer::Base.deliveries.last
    url = extract_confirmation_url(mail)
    sign_in @new_member
    visit url

    expect {
      click_button I18n.t("project.project_member.invitation.join")
      expect(page).to have_content I18n.t("project.project_member.invitation.flash.success", project: @project.name)
    }.to change(ProjectMember.where(project_id: @project.id, accepted_project_invitation: true), :count).by(1)
    sign_out @new_member

  end

  # js: trueにしておくと、2ユーザーでのログイン/ログアウトができなかったのでdeleteの正常系シナリオを分割した
  scenario "delete project member relationship", js: true do
    sign_in @user
    visit project_path(@project)

    expect {
      within "#project-member-list-#{@member.project_members.last.id}" do
        click_link I18n.t("project.crud.delete")
      end
      # confirmダイアログのテスト
      confirmation_dialog = page.driver.browser.switch_to.alert
      expect(confirmation_dialog.text).to eq I18n.t("project.crud.confirm_delete")
      confirmation_dialog.accept
      expect(page).to have_content I18n.t("project.project_member.invitation.flash.deleted")
    }.to change(@member.project_members, :count).by(-1)
  end

  scenario "invite new member then other user request to get edit_url with valid token" do
    invite_new_member
    sign_out @user

    mail = ActionMailer::Base.deliveries.last
    url = extract_confirmation_url(mail)

    other_user = User.new(name: "other_user", email: "other_user@example.com", password: "password")
    other_user.skip_confirmation!
    other_user.save!
    other_user.confirm

    sign_in other_user
    visit url

    expect(page).to have_content I18n.t("project.project_member.invitation.flash.invalid_user")
    sign_out other_user

    sign_in @new_member
    invalid_token_url = url + 'invalid'
    visit invalid_token_url
    expect(page).to have_content I18n.t("project.project_member.invitation.flash.invalid_token")
  end

  scenario "invite new member then new member request request to get edit_url with invalid token" do
    invite_new_member
    sign_out @user

    mail = ActionMailer::Base.deliveries.last
    invalid_token_url = extract_confirmation_url(mail) + 'invalid'

    sign_in @new_member
    visit invalid_token_url
    expect(page).to have_content I18n.t("project.project_member.invitation.flash.invalid_token")
  end
end