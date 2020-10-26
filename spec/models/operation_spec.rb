require 'rails_helper'

RSpec.describe Operation, type: :model do
  describe 'factory' do
    let!(:operation) {FactoryGirl.create :operation}

    # Factories
    it { expect(operation).to be_valid }

    it { should belong_to(:test_case) }
  end
end
