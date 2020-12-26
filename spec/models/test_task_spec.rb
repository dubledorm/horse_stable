require 'rails_helper'

RSpec.describe TestTask, type: :model do
  describe 'factory' do
    let!(:test_task) { FactoryGirl.create :test_task }

    # Factories
    it { expect(test_task).to be_valid }

    it { should belong_to(:experiment) }
    it { should belong_to(:user) }
  end

  describe 'scope' do
    let!(:experiment1) { FactoryGirl.create :experiment, human_name: 'name_val1_name' }
    let!(:experiment2) { FactoryGirl.create :experiment, human_name: 'name_val2_name' }
    let!(:test_task1) { FactoryGirl.create :test_task, experiment: experiment1 }
    let!(:test_task2) { FactoryGirl.create :test_task, experiment: experiment2 }

    it { expect(TestTask.experiment_name('val1').count).to eq(1) }
    it { expect(TestTask.experiment_name('val2').count).to eq(1) }

    it { expect(TestTask.experiment_name('val1')[0]).to eq(test_task1) }
    it { expect(TestTask.experiment_name('val2')[0]).to eq(test_task2) }
  end
end
