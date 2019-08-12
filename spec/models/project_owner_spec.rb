require 'rails_helper'

RSpec.describe ProjectOwner, type: :model do
  describe "association" do
    describe "belongs_to" do
      it { is_expected.to belong_to(:project) }
      it { is_expected.to belong_to(:user) }
    end
  end
end
