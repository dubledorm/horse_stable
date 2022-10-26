# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExperimentToUserGroup, type: :model do
  describe 'factory' do
    let!(:experiment_to_user_group) { FactoryGirl.create :experiment_to_user_group }

    # Factories
    it { expect(experiment_to_user_group).to be_valid }

    it { should belong_to(:experiment) }
    it { should belong_to(:user_group) }
  end
end
