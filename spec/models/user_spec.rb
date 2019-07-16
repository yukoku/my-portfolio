require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with name, email and password" do
    user = User.new(
      name: "test_user",
      email: "test@example.com",
      password: "password"
    )
    expect(user).to be_valid
  end

  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "is invalid without name" do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include(I18n.t("errors.messages.blank"))
  end

  it "is invalid over length name" do
    user = FactoryBot.build(:user, name: "a" * 51)
    user.valid?
    expect(user.errors[:name]).to include(I18n.t("errors.messages.too_long", count: 50))
  end

  it "is invalid duplicate name" do
    user = FactoryBot.create(:user)
    other_user = FactoryBot.build(:user, name: user.name, email: "other@example.com")
    other_user.valid?
    expect(other_user.errors[:name]).to include(I18n.t("errors.messages.taken"))
  end

  it { is_expected.to validate_presence_of :name }
end
