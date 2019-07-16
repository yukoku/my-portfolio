require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  # Todo: テストケースを分割する
  scenario "create new project and edit then delete", js: true do
    user = FactoryBot.create(:user)
    project = FactoryBot.build(:project)
    sign_in user
    visit projects_path

    click_link "新しいプロジェクト"

    fill_in "名前", with: project.name
    fill_in "説明", with: project.description
    # 期日を設定すると全て年情報に値が入力されてうまく行かないのでデフォルトの値を使用する

    expect {
      click_button "作成"
      expect(page).to have_content "新しいプロジェクトが作成されました。"
    }.to change(Project, :count).by(1)

    click_link "編集"
    fill_in "説明", with: project.description + "test description"
    click_button "更新"
    expect(page).to have_content "プロジェクトを更新しました。"

    visit projects_path

    expect {
      click_link "削除"
      # confirmダイアログのテスト
      confirmation_dialog = page.driver.browser.switch_to.alert
      expect(confirmation_dialog.text).to eq "本当に削除しますか?"
      confirmation_dialog.accept
      expect(page).to have_content "プロジェクトを削除しました。"
    }.to change(Project, :count).by(-1)
  end
end
