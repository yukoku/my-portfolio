require 'rails_helper'

RSpec.feature "Projects", type: :system do
  scenario "create new project and edit then delete", js: true do
    user = FactoryBot.create(:user)
    project = user.projects.first
    user.confirm
    sign_in user
    visit projects_path

    click_link I18n.t("project.title.new")

    form_label = "activerecord.attributes.project"
    fill_in I18n.t("#{form_label}.name"), with: project.name
    fill_in I18n.t("#{form_label}.description"), with: project.description
    # 期日を設定すると全て年情報に値が入力されてうまく行かないのでデフォルトの値を使用する

    expect {
      click_button I18n.t("helpers.submit.create")
      expect(page).to have_content I18n.t("project.crud.flash.created")
    }.to change(Project, :count).by(1)

    new_project = Project.last
    within "#owner-selection-#{new_project.id}" do
      click_link I18n.t("project.crud.edit")
    end
    fill_in I18n.t("#{form_label}.description"), with: new_project.description + "test description"
    click_button I18n.t("helpers.submit.update")
    expect(page).to have_content I18n.t("project.crud.flash.updated")

    visit projects_path

    expect {
      within "#owner-selection-#{new_project.id}" do
        click_link I18n.t("project.crud.delete")
      end
      # confirmダイアログのテスト
      confirmation_dialog = page.driver.browser.switch_to.alert
      expect(confirmation_dialog.text).to eq I18n.t("project.crud.confirm_delete")
      confirmation_dialog.accept
      expect(page).to have_content I18n.t("project.crud.flash.deleted")
    }.to change(Project, :count).by(-1)
  end
end
