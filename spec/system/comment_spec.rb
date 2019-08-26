require 'rails_helper'

RSpec.feature "Comments", type: :system do
  scenario "create comment and delete", js: true do
    user = FactoryBot.create(:user)
    project = user.projects.first
    ticket = project.tickets.first
    user.confirm
    sign_in user
    visit project_ticket_path(project, ticket)

    form_label = "activerecord.attributes.comment"
    fill_in I18n.t("#{form_label}.content"), with: "test"

    expect {
      click_button I18n.t("comment.crud.create")
      expect(page).to have_content I18n.t("comment.crud.flash.created")
    }.to change(Comment, :count).by(1)

    new_comment = Comment.last
    expect {
      within "#comment-content-#{new_comment.id}" do
        click_link I18n.t("comment.crud.delete")
      end
      # confirmダイアログのテスト
      confirmation_dialog = page.driver.browser.switch_to.alert
      expect(confirmation_dialog.text).to eq I18n.t("comment.crud.confirm_delete")
      confirmation_dialog.accept
      expect(page).to have_content I18n.t("comment.crud.flash.deleted")
    }.to change(Comment, :count).by(-1)
  end
end
