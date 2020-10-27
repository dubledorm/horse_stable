require 'rails_helper'

RSpec.describe Experiment, type: :model do
  describe 'factory' do
    let!(:experiment) {FactoryGirl.create :experiment}

    # Factories
    it { expect(experiment).to be_valid }

    it { should belong_to(:user) }
    it { should have_many(:test_cases) }
  end
end
