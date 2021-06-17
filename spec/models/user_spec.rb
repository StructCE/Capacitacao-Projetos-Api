require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'standard' do
    it 'be_valid' do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  describe 'validations' do
    context 'name is nil' do
      it { expect(build(:user, name: nil)).to_not be_valid }
    end

    context 'name is too small' do
      it { expect(build(:user, name: 'oi')).to_not be_valid }
    end

    context 'email is nil' do
      it { expect(build(:user, email: nil)).to_not be_valid }
    end
  end
end
