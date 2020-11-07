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

  describe 'serialization' do
    let!(:empty_experiment_case) {FactoryGirl.create :experiment_case}
    let!(:experiment_case_with_operations) { FactoryGirl.create :experiment_case_with_operations}
    let!(:empty_result) { { 'check' => {}, 'do' => {}, 'next' => {} } }
    let!(:result) { { 'check' => { experiment_case_with_operations.operations[1].number.to_s => {},
                                         experiment_case_with_operations.operations[2].number.to_s => {},
                                         experiment_case_with_operations.operations[3].number.to_s => { 'do' => 'click',
                                                                                                        'human_description' => nil,
                                                                                                        'human_name' =>nil,
                                                                                                        'selector' => { "xpath" => "123" } } },
                            'do' => { experiment_case_with_operations.operations[0].number.to_s => {} },
                            'next' => {} } }

    it { expect(empty_experiment_case.as_json).to eq(empty_result) }
    it { expect(JSON.parse(empty_experiment_case.as_json.to_json)).to eq(empty_result) }

    it { expect(experiment_case_with_operations.as_json).to eq(result) }
    it { expect(JSON.parse(experiment_case_with_operations.as_json.to_json)).to eq(result) }

    it { ap empty_experiment_case.as_json }
    it { ap experiment_case_with_operations.as_json }
  end

  describe 'deserialization' do
    let!(:experiment) { FactoryGirl.create(:experiment) }
    let!(:user){ FactoryGirl.create(:user) }
    let(:example) { { human_name: 'Name',
                      human_description: 'Description',
                      experiment_id: experiment.id,
                      user_id: user.id,
                      number: 1,
                      check: {},
                      do: { "1" => { "human_name" => nil,
                                     "human_description" => nil,
                                     "do" => "click",
                                     "selector" => {"name" => "vote_radio_1"} } },
                      next: {"1" => {"human_name" => nil,
                                     "human_description" => nil,
                                     "do" => "click",
                                     "selector" => {"xpath" => "//fieldset[2]/button"} } } } }
    let(:experiment_case) { ExperimentCase.new }

    before :each do
      experiment_case.from_json(example.to_json)
      experiment_case.save
    end

    it { expect(experiment_case).to be_valid }
    it { expect(experiment_case.operations.count).to eq(2) }
    it { expect(Functions::Factory.build!(experiment_case.operations[1].function_name).class).to eq(Functions::Click) }
    it 'should set the selector' do
      function = Functions::Factory.build!(experiment_case.operations[1].function_name)
      function.attributes= JSON.parse(experiment_case.operations[1].operation_json)
      expect(function.selector).to eq({ "xpath" => "//fieldset[2]/button" })
    end
  end
end
