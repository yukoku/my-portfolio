require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:project) { FactoryBot.create(:project) }
  describe "association" do
    describe "belongs_to" do
      it { is_expected.to belong_to(:project) }
      it { is_expected.to belong_to(:assignee).class_name("User").optional }
      it { is_expected.to belong_to(:creator).class_name("User").optional }
    end
    describe "has_many" do
      it { is_expected.to have_many(:comments) }
    end
  end

  it "is valid with title, description, due_on and project_id" do
    ticket = Ticket.create(
      title: "Test Ticket",
      description: "This is test ticket",
      due_on: 1.day.after,
      project_id: project.id)
    expect(ticket).to be_valid
  end

  it "is valid with due on today" do
    ticket = FactoryBot.build(:ticket, due_on: Time.zone.now)
    ticket.project_id = project.id
    expect(ticket).to be_valid
  end

  it "is valid with empty due" do
    ticket = FactoryBot.build(:ticket, due_on: '')
    ticket.project_id = project.id
    expect(ticket).to be_valid
  end

  it "is invalid with due on past date" do
    ticket = FactoryBot.build(:ticket, due_on: 1.day.ago)
    ticket.valid?
    expect(ticket.errors[:due_on]).to include(I18n.t("errors.messages.on_or_after", restriction: Time.zone.today))
  end

  describe "with attached files" do
    before do
      @ticket = FactoryBot.create(:ticket, project_id: project.id)
    end
    describe "validate with file size" do
      it "is valid with under 512KB file" do
        file_path = Rails.root.to_s + '/spec/support/test_files/test_512KB.png'
        File.open(file_path) { |f| @ticket.attached_files.attach(io: f, filename: "test.png", content_type: 'image/png')}
        @ticket.valid?
        expect(@ticket).to be_valid
      end
      it "is invalid with over 512KB file" do
        file_path = Rails.root.to_s + '/spec/support/test_files/test_513KB.png'
        File.open(file_path) { |f| @ticket.attached_files.attach(io: f, filename: "test.png", content_type: 'image/png')}
        @ticket.valid?
        expect(@ticket.errors[:file]).to include(I18n.t("errors.messages.file_too_large", file_size: "512Kbyte"))
      end
    end

    describe "validate with file count" do
      it "is valid with 10 attached files" do
        files = []
        10.times do |n|
          file_path = Rails.root.to_s + "/spec/support/test_files/test_#{(n + 1).to_s.rjust(2, '0')}.png"
          files << { io: File.open(file_path), filename: "test#{n + 1}.png" }
        end
        @ticket.attached_files.attach files
        @ticket.valid?
        expect(@ticket).to be_valid
      end
      it "is invalid with 11 attached files" do
        11.times do |n|
          file_path = Rails.root.to_s + "/spec/support/test_files/test_#{(n + 1).to_s.rjust(2, '0')}.png"
          File.open(file_path) { |f| @ticket.attached_files.attach(io: f, filename: "test#{n + 1}.png", content_type: 'image/png')}
        end
        @ticket.valid?
        expect(@ticket.errors[:file]).to include(I18n.t("errors.messages.file_too_many", file_count: 10))
      end
    end
  end
end
