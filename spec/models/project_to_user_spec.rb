# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectToUser, type: :model do
  describe 'factory' do
    let!(:project_to_user) { FactoryGirl.create :project_to_user }

    # Factories
    it { expect(project_to_user).to be_valid }

    it { should belong_to(:user) }
    it { should belong_to(:project) }
    it { should validate_presence_of(:access_right) }
  end

  describe 'access_right' do
    let(:project_to_user) { FactoryGirl.create :project_to_user }

    it 'wrong access_right value' do
      project_to_user.access_right = 'wrong_value'
      expect(project_to_user).to be_invalid
    end
  end
end
