# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserGroup, type: :model do
  describe 'factory' do
    let!(:user_group) { FactoryGirl.create :user_group }

    # Factories
    it { expect(user_group).to be_valid }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:user_id) }

    it { should belong_to(:user) }
    it { should have_many(:user_to_user_groups) }
    it { should have_many(:members) }
  end
end
