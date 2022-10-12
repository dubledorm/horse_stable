require 'rails_helper'

RSpec.describe Experiment, type: :model do
  describe 'factory' do
    let!(:experiment) {FactoryGirl.create :experiment}

    # Factories
    it { expect(experiment).to be_valid }

    it { should belong_to(:user) }
    it { should have_many(:experiment_cases) }
    it { should have_many(:operations) }
  end

  describe 'serialialization' do
    context 'when experiment empty' do
      let!(:experiment) { FactoryGirl.create :experiment }
      let!(:result) { { 'id' => experiment.id,
                        'human_name' => experiment.human_name,
                        'human_description' => experiment.human_description,
                        'user_id' => experiment.user_id,
                        'state' => 'new',
                        'created_at' => experiment.created_at.xmlschema(ActiveSupport::JSON::Encoding.time_precision),
                        'updated_at' => experiment.updated_at.xmlschema(ActiveSupport::JSON::Encoding.time_precision),
                        'experiment_cases' => [],
                        'sets_of_variables_json' => nil} }

      it 'only print' do
        ap experiment.as_json
      end
      it { expect(JSON.parse(experiment.to_json)).to eq(result) }
    end

    context 'when experiment not empty' do
      let!(:experiment) { FactoryGirl.create :experiment_with_operations }
      let!(:result) { { 'id' => experiment.id,
                        'human_name' => experiment.human_name,
                        'human_description' => experiment.human_description,
                        'user_id' => experiment.user_id,
                        'state' => 'new',
                        'created_at' => experiment.created_at.xmlschema(ActiveSupport::JSON::Encoding.time_precision),
                        'updated_at' => experiment.updated_at.xmlschema(ActiveSupport::JSON::Encoding.time_precision),
                        'experiment_cases' => [ experiment.experiment_cases[0].as_json ],
                        'sets_of_variables_json' => nil} }

      it 'only print' do
        ap experiment.as_json
      end
      it { expect(JSON.parse(experiment.to_json)).to eq(result) }
    end

    context 'delete_ids' do
      let!(:experiment) { FactoryGirl.create :experiment_with_operations }

      it { expect(experiment.as_json['id']).to_not eq(nil) }
      it { expect(experiment.as_json(delete_ids: true)['id']).to eq(nil) }
    end
  end

  describe 'deserialization' do
    context 'when experiment empty' do
      let!(:experiment) {FactoryGirl.create :experiment}
      let!(:experiment_as_json) { experiment.as_json }
      let(:experiment1) { Experiment.new }

      before :each do
        experiment1.from_json(experiment_as_json.to_json)
      end

      it { ap experiment_as_json }
      it { expect(experiment1.as_json).to eq(experiment_as_json) }
    end

    context 'when experiment not empty' do
      let!(:experiment) { FactoryGirl.create :experiment_with_operations }
      let!(:experiment_as_json) { experiment.as_json }
      let(:experiment1) { Experiment.new }

      before :each do
        experiment1.from_json(experiment_as_json.to_json)
      end

      it { ap experiment_as_json }
      it { expect(experiment1.as_json).to eq(experiment_as_json) }
    end
  end


  describe 'last_test_task' do
    let!(:user1) { FactoryGirl.create :user }
    let!(:user2) { FactoryGirl.create :user }
    let!(:experiment) { FactoryGirl.create :experiment }
    let!(:test_task1) { FactoryGirl.create :test_task, state: 'completed', user: user1, experiment: experiment }
    let!(:test_task2) { FactoryGirl.create :test_task, state: 'completed', user: user1, experiment: experiment }
    let!(:test_task3) { FactoryGirl.create :test_task, state: 'completed', user: user2, experiment: experiment }

    it { expect(experiment.last_test_task(user1)).to eq(test_task2) }
  end

  describe 'clone' do
    let!(:experiment) { FactoryGirl.create :experiment_with_operations }
    let(:subject) { experiment.clone }

    it { expect(subject.user_id).to eq(experiment.user_id) }
    it { expect(subject.experiment_cases.length).to eq(experiment.experiment_cases.length) }

    it 'duplicate' do
      experiment_new = subject
      experiment_new.experiment_cases.first.human_name = 'новое значение'
      expect(subject.experiment_cases.first.human_name).to eq('новое значение')
      expect(experiment.experiment_cases.first.human_name).to_not eq('новое значение')
    end

    it 'duplicate experiment_cases count' do
      experiment_new = subject
      experiment_new.save!
      experiment_new.reload
      expect(experiment_new.experiment_cases.count).to eq(experiment.experiment_cases.count)
    end
  end
end
