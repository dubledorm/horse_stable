require 'rails_helper'

RSpec.describe Experiment, type: :model do
  describe 'factory' do
    let!(:experiment) {FactoryGirl.create :experiment}

    # Factories
    it { expect(experiment).to be_valid }

    it { should belong_to(:user) }
    it { should have_many(:experiment_cases) }
  end

  describe 'serialializable' do
    let!(:experiment) {FactoryGirl.create :experiment}
    let!(:experiment_case) {FactoryGirl.create :experiment_case, experiment: experiment}
    let!(:result) { { '1' => { 'check' => {}, 'do' => {}, 'human_name' => experiment_case.human_name, 'next' => {}},
                            'human_description' => nil,
                            'human_name' => experiment.human_name } }

    it { expect(JSON.parse(experiment.to_json)).to eq(result) }
  end

  describe 'last_test_task' do
    let!(:user1) { FactoryGirl.create :user }
    let!(:user2) { FactoryGirl.create :user }
    let!(:experiment) { FactoryGirl.create :experiment }
    let!(:test_task1) { FactoryGirl.create :test_task, user: user1, experiment: experiment }
    let!(:test_task2) { FactoryGirl.create :test_task, user: user1, experiment: experiment }
    let!(:test_task3) { FactoryGirl.create :test_task, user: user2, experiment: experiment }

    it { expect(experiment.last_test_task(user1)).to eq(test_task2) }
  end
end
