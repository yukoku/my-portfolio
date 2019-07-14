require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with name, email and password"
  it "is invalid without name"
  it "is invalid without email"
  it { is_expected.to validate_presence_of :name }
end
