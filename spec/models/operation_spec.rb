require 'rails_helper'

RSpec.describe Operation, type: :model do
  describe 'factory' do
    let!(:operation) {FactoryGirl.create :operation}

    # Factories
    it { expect(operation).to be_valid }

    it { should belong_to(:test_case) }
  end

  describe 'uniqness number' do
    let!(:test_case) {FactoryGirl.create :test_case}
    let!(:operation1) {FactoryGirl.create :operation, test_case: test_case, number: '1', operation_type: :check}
    let(:operation2) {FactoryGirl.build :operation, test_case: test_case, number: '2', operation_type: :check}
    let(:operation3) {FactoryGirl.build :operation, test_case: test_case, number: '1', operation_type: :check}
    let(:operation4) {FactoryGirl.build :operation, test_case: test_case, number: '1', operation_type: :do}

    it { expect(operation1).to be_valid }
    it { expect(operation2).to be_valid }
    it { expect(operation3).to_not be_valid }
    it { expect(operation4).to be_valid }

  end
end
