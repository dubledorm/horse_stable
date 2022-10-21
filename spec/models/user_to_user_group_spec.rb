# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserToUserGroup, type: :model do
  describe 'factory' do
    let!(:user_to_user_group) { FactoryGirl.create :user_to_user_group }

    # Factories
    it { expect(user_to_user_group).to be_valid }

    it { should belong_to(:user) }
    it { should belong_to(:user_group) }
    it { should validate_presence_of(:access_right) }
  end

  describe 'access_right' do
    let(:user_to_user_group) { FactoryGirl.create :user_to_user_group }

    it 'wrong access_right value' do
      user_to_user_group.access_right = 'wrong_value'
      expect(user_to_user_group).to be_invalid
    end
  end
end
