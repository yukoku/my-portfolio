require 'rails_helper'

RSpec.feature "Tickets", type: :feature do
  scenario "create new ticket and edit then delete", js: true do
    user = FactoryBot.create(:user)
    project = user.projects.first
    ticket = project.tickets.first
    user.confirm
    sign_in user
    visit project_path(project)

    click_link I18n.t("project.tickets.create")

    form_label = "activerecord.attributes.ticket"
    fill_in I18n.t("#{form_label}.title"), with: ticket.title
    fill_in I18n.t("#{form_label}.description"), with: ticket.description
    select user.name, from: 'ticket[assignee_id]'
    select project.ticket_attributes.first.ticket_attribute, from:'ticket[ticket_attribute_id]'
    select project.ticket_statuses.first.status, from:'ticket[ticket_status_id]'
    select project.ticket_priorities.first.priority, from:'ticket[ticket_priority_id]'
    file_path = Rails.root.join('spec', 'support', 'test_files', 'for-feature-spec.jpg')
    attach_file(I18n.t("#{form_label}.attached_files"), file_path)
    # 期日を設定すると全て年情報に値が入力されてうまく行かないのでデフォルトの値を使用する

    expect {
      click_button I18n.t("helpers.submit.create")
      expect(page).to have_content I18n.t("ticket.crud.flash.created")
    }.to change(Ticket, :count).by(1)

    new_ticket = Ticket.last
    within ".ticket-crud" do
      click_link I18n.t("ticket.crud.edit")
    end

    fill_in I18n.t("#{form_label}.description"), with: new_ticket.description + "test description"
    click_button I18n.t("helpers.submit.update")
    expect(page).to have_content I18n.t("ticket.crud.flash.updated")

    expect {
      within ".ticket-crud" do
        click_link I18n.t("ticket.crud.delete")
      end
      # confirmダイアログのテスト
      confirmation_dialog = page.driver.browser.switch_to.alert
      expect(confirmation_dialog.text).to eq I18n.t("ticket.crud.confirm_delete")
      confirmation_dialog.accept
      expect(page).to have_content I18n.t("ticket.crud.flash.deleted")
    }.to change(Ticket, :count).by(-1)
  end
end
