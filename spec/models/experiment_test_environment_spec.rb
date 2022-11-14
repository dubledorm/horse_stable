# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExperimentTestEnvironment, type: :model do
  describe 'factory' do
    let(:experiment_test_environment) { FactoryGirl.create :experiment_test_environment }

    # Factories
    it { expect(experiment_test_environment).to be_valid }

    it { should belong_to(:test_environment) }
    it { should belong_to(:experiment) }
    it { should have_one(:test_environment_project) }
    it { should have_one(:experiment_project) }
    it { should have_many(:environment_variables) }
  end

  describe 'test_environment uniqueness' do
    context 'when test_environment uniqueness in bound of experiment' do
      let!(:project) { FactoryGirl.create :project }
      let!(:experiment) { FactoryGirl.create :experiment, project: project }
      let!(:test_environment1) { FactoryGirl.create :test_environment, project: project }
      let!(:test_environment2) { FactoryGirl.create :test_environment, project: project }
      let!(:experiment_test_environment1) do
        FactoryGirl.create :experiment_test_environment,
                           experiment: experiment, test_environment: test_environment1
      end
      let!(:experiment_test_environment2) do
        FactoryGirl.build :experiment_test_environment,
                          experiment: experiment, test_environment: test_environment2
      end

      it { expect(experiment_test_environment2).to be_valid }
    end

    context 'when test_environment is not uniqueness in bound of experiment' do
      let!(:project) { FactoryGirl.create :project }
      let!(:experiment) { FactoryGirl.create :experiment, project: project }
      let!(:test_environment1) { FactoryGirl.create :test_environment, project: project }
      let!(:experiment_test_environment1) do
        FactoryGirl.create :experiment_test_environment,
                           experiment: experiment, test_environment: test_environment1
      end
      let!(:experiment_test_environment2) do
        FactoryGirl.build :experiment_test_environment,
                          experiment: experiment, test_environment: test_environment1
      end

      it { expect(experiment_test_environment2).to be_invalid }
    end
  end

  describe 'project' do
    context 'when test_environment project equal to experiment project' do
      let!(:project) { FactoryGirl.create :project }
      let!(:experiment) { FactoryGirl.create :experiment, project: project }
      let!(:test_environment) { FactoryGirl.create :test_environment, project: project }

      let(:experiment_test_environment) do
        FactoryGirl.build :experiment_test_environment, experiment: experiment,
                                                        test_environment: test_environment
      end

      it { expect(experiment_test_environment).to be_valid }
    end

    context 'when test_environment project not equal to experiment project' do
      let!(:project1) { FactoryGirl.create :project }
      let!(:project2) { FactoryGirl.create :project }
      let!(:experiment) { FactoryGirl.create :experiment, project: project1 }
      let!(:test_environment) { FactoryGirl.create :test_environment, project: project2 }

      let(:experiment_test_environment) do
        FactoryGirl.build :experiment_test_environment, experiment: experiment,
                                                        test_environment: test_environment
      end

      it { expect(experiment_test_environment).to be_invalid }
    end
  end
end
