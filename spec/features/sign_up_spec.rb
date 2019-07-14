require 'rails_helper'

RSpec.feature "SignUp", type: :feature do
  scenario "sign up and sign out" do
    user = FactoryBot.build(:user)
    visit root_path

    within ".sign-in" do
      click_link "ユーザー登録"
    end
    fill_in "名前", with: user.name
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    fill_in "確認用パスワード", with: user.password

    expect {
      click_button "Sign up"
      expect(page).to have_content "アカウント登録が完了しました。"
      within ".sign-in" do
        click_link "ログアウト"
      end
      expect(page).to have_content "ログアウトしました。"
    }.to change(User, :count).by(1)
  end
end
