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

  describe 'variables' do
    let(:experiment_test_environment) { FactoryGirl.create :experiment_test_environment }

    it { expect(experiment_test_environment.environment_variables.count).to eq(0) }

    context 'when add two variables' do
      before :each do
        experiment_test_environment.environment_variables << EnvironmentVariable.new(key: 'key1', value: 'value1')
        experiment_test_environment.environment_variables << EnvironmentVariable.new(key: 'key2', value: 'value2')
      end

      it { expect(experiment_test_environment.environment_variables.count).to eq(2) }
    end
  end

  describe 'serialize to json' do
    context 'when serialize on object' do
      let(:experiment_test_environment) { FactoryGirl.create :experiment_test_environment }
      before :each do
        experiment_test_environment.environment_variables << EnvironmentVariable.new(key: 'key1', value: 'value1')
        experiment_test_environment.environment_variables << EnvironmentVariable.new(key: 'key2', value: 'value2')
      end

      it { expect(experiment_test_environment.environment_variables.count).to eq(2) }
      it { puts(JSON.parse(experiment_test_environment.decorate.to_json)) }
      it { expect(JSON.parse(experiment_test_environment.decorate.to_json)['environment_variables'].count).to eq(2) }
    end

    context 'when serialize collection' do
      let(:experiment_test_environment1) { FactoryGirl.create :experiment_test_environment }
      let(:experiment_test_environment2) { FactoryGirl.create :experiment_test_environment }
      let(:experiment) { FactoryGirl.create :experiment }
      before :each do
        experiment_test_environment1.environment_variables << EnvironmentVariable.new(key: 'key11', value: 'value11')
        experiment_test_environment1.environment_variables << EnvironmentVariable.new(key: 'key12', value: 'value12')
        experiment_test_environment2.environment_variables << EnvironmentVariable.new(key: 'key21', value: 'value21')
        experiment_test_environment2.environment_variables << EnvironmentVariable.new(key: 'key22', value: 'value22')
        experiment.experiment_test_environments << experiment_test_environment1
        experiment.experiment_test_environments << experiment_test_environment2
      end

      # it { puts(ExperimentTestEnvironmentsCollectionDecorator.decorate(experiment.experiment_test_environments).to_json) }
      # it { puts(ExperimentTestEnvironmentDecorator.decorate_collection(experiment.experiment_test_environments).to_json) }

      it {
        expect(JSON.parse(ExperimentTestEnvironmentsCollectionDecorator
                               .decorate(experiment.experiment_test_environments)
                               .to_json)[0]['environment_variables'][0]['key']).to eq('key11')
      }
      it {
        expect(JSON.parse(ExperimentTestEnvironmentsCollectionDecorator
                            .decorate(experiment.experiment_test_environments)
                            .to_json)[1]['environment_variables'][1]['value']).to eq('value22')
      }
      it {
        expect(JSON.parse(ExperimentTestEnvironmentsCollectionDecorator
                            .decorate(experiment.experiment_test_environments)
                            .to_json)[0]['name']).to eq(experiment_test_environment1.test_environment.name)
      }

    end
  end
end
