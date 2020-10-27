require 'rails_helper'

RSpec.describe TestCase, type: :model do
  describe 'factory' do
    let!(:test_case) {FactoryGirl.create :test_case}

    # Factories
    it { expect(test_case).to be_valid }

    it { should belong_to(:user) }
    it { should belong_to(:experiment) }
    it { should have_many(:operations) }
  end
end
