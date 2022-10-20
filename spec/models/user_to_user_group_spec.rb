# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserToUserGroup, type: :model do
  describe 'factory' do
    let!(:user_to_user_group) { FactoryGirl.create :user_to_user_group }

    # Factories
    it { expect(user_to_user_group).to be_valid }

    it { should belong_to(:user) }
    it { should belong_to(:user_group) }
  end
end
