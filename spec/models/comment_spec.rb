require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { FactoryBot.create(:user)}
  describe "association" do
    describe "belongs_to" do
      it { is_expected.to belong_to(:ticket) }
      it { is_expected.to belong_to(:user) }
    end
  end

  def new_comment(content: "test", user_id: user.id, ticket_id: user.projects.first.tickets.first.id)
    comment = Comment.new(
      content: content,
      user_id: user_id,
      ticket_id: ticket_id)
  end

  it "is valid with content, user_id and ticket_id" do
    comment = new_comment
    expect(comment).to be_valid
  end

  it "is invalid without content" do
    comment = new_comment(content: nil)
    comment.valid?
    expect(comment.errors.messages[:content]).to include(I18n.t("errors.messages.blank"))
  end

  it "is invalid without user" do
    comment = new_comment(user_id: nil)
    comment.valid?
    expect(comment.errors.messages[:user_id]).to include(I18n.t("errors.messages.blank"))
  end

  it "is invalid without ticket" do
    comment = new_comment(ticket_id: nil)
    comment.valid?
    expect(comment.errors.messages[:ticket_id]).to include(I18n.t("errors.messages.blank"))
  end

  it "is invalid with 256 charcters content" do
    comment = new_comment(content: "a" * 256)
    comment.valid?
    expect(comment.errors.messages[:content]).to include(I18n.t("errors.messages.too_long", count: 255))
  end
end
