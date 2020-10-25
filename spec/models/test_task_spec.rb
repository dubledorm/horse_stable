require 'rails_helper'

RSpec.describe TestTask, type: :model do
  describe 'factory' do
    let!(:test_task) {FactoryGirl.create :test_task}

    # Factories
    it { expect(test_task).to be_valid }

  end
end
