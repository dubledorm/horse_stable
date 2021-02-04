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
    let!(:empty_result) { { 'check' => [], 'do' => [], 'next' => [],
                            "id" => empty_experiment_case.id,
                            "human_name" => empty_experiment_case.human_name,
                            "human_description" => empty_experiment_case.human_description,
                            "user_id" => empty_experiment_case.user_id,
                            "created_at" => empty_experiment_case.created_at.xmlschema(ActiveSupport::JSON::Encoding.time_precision),
                            "updated_at" => empty_experiment_case.updated_at.xmlschema(ActiveSupport::JSON::Encoding.time_precision),
                            "number" => empty_experiment_case.number,
                            "experiment_id" => empty_experiment_case.experiment_id } }
    # let!(:result) { { 'check' => { experiment_case_with_operations.operations[1].number.to_s => { 'operation_id' => experiment_case_with_operations.operations[1].id, 'operation_json' => {} },
    #                                      experiment_case_with_operations.operations[2].number.to_s => { 'operation_id' => experiment_case_with_operations.operations[2].id, 'operation_json' => {} },
    #                                      experiment_case_with_operations.operations[3].number.to_s => { 'operation_id' => experiment_case_with_operations.operations[3].id,
    #                                                                                                     'operation_json' => { 'do' => 'click',
    #                                                                                                                       'human_description' => nil,
    #                                                                                                                       'human_name' =>nil,
    #                                                                                                                       'selector' => { "xpath" => "123" }
    #                                                                                                     } } },
    #                         'do' => { experiment_case_with_operations.operations[0].number.to_s => {'operation_id' => experiment_case_with_operations.operations[0].id, 'operation_json' => {}} },
    #                         'next' => {},
    #                         'human_name' => experiment_case_with_operations.human_name } }

    let!(:result) { { "id" => experiment_case_with_operations.id,
                            "human_name" => experiment_case_with_operations.human_name,
                            "human_description" => experiment_case_with_operations.human_description,
                            "user_id" => experiment_case_with_operations.user_id,
                            "created_at" => experiment_case_with_operations.created_at.xmlschema(ActiveSupport::JSON::Encoding.time_precision),
                            "updated_at" => experiment_case_with_operations.updated_at.xmlschema(ActiveSupport::JSON::Encoding.time_precision),
                            "number" => experiment_case_with_operations.number,
                            "experiment_id" => experiment_case_with_operations.experiment_id,
                      'check' => [experiment_case_with_operations.operations[1].as_json,
                                  experiment_case_with_operations.operations[2].as_json,
                                  experiment_case_with_operations.operations[3].as_json],
                      'do' => [experiment_case_with_operations.operations[0].as_json],
                      'next' => []
                      }
    }



    it { expect(empty_experiment_case.as_json).to eq(empty_result) }
    it { expect(JSON.parse(empty_experiment_case.as_json.to_json)).to eq(empty_result) }

    it { ap experiment_case_with_operations.as_json }
    it { expect(experiment_case_with_operations.as_json).to eq(result) }
    it { expect(JSON.parse(experiment_case_with_operations.as_json.to_json)).to eq(result) }

    it { ap empty_experiment_case.as_json }
    it { ap experiment_case_with_operations.as_json }

    context 'delete_ids' do
      let!(:experiment_case) {FactoryGirl.create :experiment_case}

      it { expect(experiment_case.as_json['id']).to_not eq(nil) }
      it { expect(experiment_case.as_json(delete_ids: true)['id']).to eq(nil) }
    end
  end

  describe 'deserialization' do
    let!(:empty_experiment_case) {FactoryGirl.create :experiment_case}
    let!(:empty_experiment_case_as_json) { empty_experiment_case.as_json }
    let(:empty_experiment_case1) { ExperimentCase.new }

    let!(:experiment_case_with_operations) { FactoryGirl.create :experiment_case_with_operations}
    let!(:experiment_case_with_operations_as_json) { experiment_case_with_operations.as_json }
    let(:experiment_case_with_operations1) { ExperimentCase.new }


    before :each do
      empty_experiment_case1.from_json(empty_experiment_case_as_json.to_json)
      experiment_case_with_operations1.from_json(experiment_case_with_operations_as_json.to_json)
    end

    it { ap experiment_case_with_operations_as_json }
    it { expect(empty_experiment_case1.as_json).to eq(empty_experiment_case_as_json) }
    it { expect(experiment_case_with_operations1.operations.count).to eq(4)}
    it { expect(experiment_case_with_operations1.operations[2].function_name).to eq(experiment_case_with_operations.operations[2].function_name)}
    it { expect(experiment_case_with_operations1.operations[1].as_json).to eq(experiment_case_with_operations.operations[1].as_json)}
  end

  describe 'clone' do
    let!(:experiment_case_with_operations) { FactoryGirl.create :experiment_case_with_operations }
    let(:subject) { experiment_case_with_operations.clone }

    it { expect(subject.user_id).to eq(experiment_case_with_operations.user_id) }
    it { expect(subject.human_name).to eq(experiment_case_with_operations.human_name) }
    it { expect(subject.number).to_not eq(experiment_case_with_operations.number) }
    it { expect(subject.operations.length).to eq(experiment_case_with_operations.operations.length) }
    it 'duplicate' do
      experiment_case_new = subject
      experiment_case_new.operations.first.operation_json = 'новое значение'
      expect(experiment_case_new.operations.first.operation_json).to eq('новое значение')
      expect(experiment_case_with_operations.operations.first.operation_json).to_not eq('новое значение')
    end

    it 'duplicate operation count' do
      experiment_case_new = subject
      experiment_case_new.save!
      experiment_case_new.reload
      expect(experiment_case_new.operations.count).to eq(experiment_case_with_operations.operations.count)
    end
  end
end
