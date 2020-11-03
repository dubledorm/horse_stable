require 'rails_helper'

RSpec.describe ExperimentCase, type: :model do
  describe 'factory' do
    let!(:experiment_case) {FactoryGirl.create :experiment_case}

    # Factories
    it { expect(experiment_case).to be_valid }

    it { should belong_to(:user) }
    it { should belong_to(:experiment) }
    it { should have_many(:operations) }
  end
end
