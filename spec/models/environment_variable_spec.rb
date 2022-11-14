# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EnvironmentVariable, type: :model do
  describe 'factory' do
    let(:environment_variable) { FactoryGirl.create :environment_variable }

    # Factories
    it { expect(environment_variable).to be_valid }

    it { should validate_presence_of(:key) }
    it { should validate_presence_of(:value) }

    it { should belong_to(:experiment_test_environment) }
  end

  describe 'key uniqueness' do
    context 'when key uniqueness in bound of experiment_test_environment' do
      let!(:experiment_test_environment) { FactoryGirl.create :experiment_test_environment }
      let!(:environment_variable1) do
        FactoryGirl.create :environment_variable,
                           key: 'key1', experiment_test_environment: experiment_test_environment
      end
      let!(:environment_variable2) do
        FactoryGirl.build :environment_variable,
                          key: 'key2', experiment_test_environment: experiment_test_environment
      end

      it { expect(environment_variable2).to be_valid }
    end

    context 'when key is not uniqueness in bound of experiment_test_environment' do
      let!(:experiment_test_environment) { FactoryGirl.create :experiment_test_environment }
      let!(:environment_variable1) do
        FactoryGirl.create :environment_variable,
                           key: 'key1', experiment_test_environment: experiment_test_environment
      end
      let!(:environment_variable2) do
        FactoryGirl.build :environment_variable,
                          key: 'key1', experiment_test_environment: experiment_test_environment
      end

      it { expect(environment_variable2).to be_invalid }
    end
  end
end
