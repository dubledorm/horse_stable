# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TestEnvironment, type: :model do
  describe 'factory' do
    let(:test_environment) { FactoryGirl.create :test_environment }

    # Factories
    it { expect(test_environment).to be_valid }

    it { should validate_presence_of(:name) }

    it { should belong_to(:project) }
    it { should have_many(:experiment_test_environments) }
  end

  describe 'name uniqueness' do
    context 'when name uniqueness in bound of project' do
      let!(:project) { FactoryGirl.create :project }
      let!(:test_environment1) { FactoryGirl.create :test_environment, name: 'name1', project: project }
      let!(:test_environment2) { FactoryGirl.build :test_environment, name: 'name2', project: project }

      it { expect(test_environment2).to be_valid }
    end

    context 'when name is not uniqueness in bound of project' do
      let!(:project) { FactoryGirl.create :project }
      let!(:test_environment1) { FactoryGirl.create :test_environment, name: 'name1', project: project }
      let!(:test_environment2) { FactoryGirl.build :test_environment, name: 'name1', project: project }

      it { expect(test_environment2).to be_invalid }
    end
  end
end
