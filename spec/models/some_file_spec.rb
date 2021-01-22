require 'rails_helper'

RSpec.describe SomeFile, type: :model do
  describe 'factory' do
    let!(:some_file) {FactoryGirl.create :some_file}

    # Factories
    it { expect(some_file).to be_valid }

    it { should belong_to(:user) }
  end
end
