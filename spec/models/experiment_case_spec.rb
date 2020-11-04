require 'rails_helper'

RSpec.describe ExperimentCase, type: :model do
  describe 'factory' do
    let!(:experiment_case) {FactoryGirl.create :experiment_case}
    let!(:experiment_case_with_operations) { FactoryGirl.create :experiment_case_with_operations}

    # Factories
    it { expect(experiment_case).to be_valid }
    it { expect(experiment_case_with_operations).to be_valid }

    it { should belong_to(:user) }
    it { should belong_to(:experiment) }
    it { should have_many(:operations) }
  end

  describe 'serializable' do
    let!(:empty_experiment_case) {FactoryGirl.create :experiment_case}
    let!(:experiment_case_with_operations) { FactoryGirl.create :experiment_case_with_operations}
    let!(:empty_result) { { 'check' => {}, 'do' => {}, 'next' => {} } }
    let!(:result) { { 'check' => { experiment_case_with_operations.operations[1].number.to_s => {},
                                         experiment_case_with_operations.operations[2].number.to_s => {},
                                         experiment_case_with_operations.operations[3].number.to_s => { 'function_name' => 'click',
                                                                                                        'human_description' => nil,
                                                                                                        'human_name' =>nil,
                                                                                                        'selector' => '{"xpath":"123"}' } },
                            'do' => { experiment_case_with_operations.operations[0].number.to_s => {} },
                            'next' => {} } }

    it { expect(empty_experiment_case.as_json).to eq(empty_result) }
    it { expect(JSON.parse(empty_experiment_case.as_json.to_json)).to eq(empty_result) }

    it { expect(experiment_case_with_operations.as_json).to eq(result) }
    it { expect(JSON.parse(experiment_case_with_operations.as_json.to_json)).to eq(result) }

    it { ap empty_experiment_case.as_json }
    it { ap experiment_case_with_operations.as_json }
  end
end
