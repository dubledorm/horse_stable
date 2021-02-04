require 'rails_helper'

RSpec.describe Operation, type: :model do
  describe 'factory' do
    let!(:operation) {FactoryGirl.create :operation}

    # Factories
    it { expect(operation).to be_valid }

    it { should belong_to(:experiment_case) }
  end

  describe 'uniqness number' do
    let!(:experiment_case) {FactoryGirl.create :experiment_case}
    let!(:operation1) {FactoryGirl.create :operation, experiment_case: experiment_case, number: '1', operation_type: :check}
    let(:operation2) {FactoryGirl.build :operation, experiment_case: experiment_case, number: '2', operation_type: :check}
    let(:operation3) {FactoryGirl.build :operation, experiment_case: experiment_case, number: '1', operation_type: :check}
    let(:operation4) {FactoryGirl.build :operation, experiment_case: experiment_case, number: '1', operation_type: :do}

    it { expect(operation1).to be_valid }
    it { expect(operation2).to be_valid }
    it { expect(operation3).to_not be_valid }
    it { expect(operation4).to be_valid }

  end

  describe 'serializable' do
    context 'simple operation' do
      let!(:operation) {FactoryGirl.create :operation}
      let(:result) { { "id" => operation.id,
                       "created_at" => operation.created_at.xmlschema(ActiveSupport::JSON::Encoding.time_precision),
                       "updated_at" => operation.updated_at.xmlschema(ActiveSupport::JSON::Encoding.time_precision),
                       'function_name' => operation.function_name,
                       'number' => operation.number,
                       'experiment_case_id' => operation.experiment_case_id,
                       'operation_type' => operation.operation_type,
                       "operation_json" => { "human_name" => nil,
                                            "human_description" => nil,
                                            "do" => "click",
                                            "selector" => nil
                      }
      } }

      it 'only print' do
        ap operation.as_json(functions_translate: true)
      end

      it { expect(operation.as_json(functions_translate: true)).to eq(result) }
    end

    context 'sub_script' do
      let(:experiment_with_operations) { FactoryGirl.create :experiment_with_operations }
      let(:result) {{}}
    end

    context 'delete_ids' do
      let!(:operation) {FactoryGirl.create :operation}

      it { expect(operation.as_json['id']).to_not eq(nil) }
      it { expect(operation.as_json(delete_ids: true)['id']).to eq(nil) }
    end

    context 'operation_json' do
      let!(:operation) {FactoryGirl.create :operation_with_function}
      let(:result) { { "id" => operation.id,
                       "created_at" => operation.created_at.xmlschema(ActiveSupport::JSON::Encoding.time_precision),
                       "updated_at" => operation.updated_at.xmlschema(ActiveSupport::JSON::Encoding.time_precision),
                       'function_name' => 'click',
                       'number' => operation.number,
                       'experiment_case_id' => operation.experiment_case_id,
                       'operation_type' => operation.operation_type,
                       "operation_json" => { "human_name" => nil,
                                             "human_description" => nil,
                                             "do" => "click",
                                             "selector" => { "xpath" => "//fieldset[17]/button[2]" }
                       }
      } }

      it 'only print' do
        ap operation.as_json(functions_translate: true)
      end

      it { expect(operation.as_json['operation_json']).to eq(result['operation_json']) }
      it { expect(JSON.parse(operation.to_json)['operation_json']).to eq(result['operation_json']) }
    end
  end

  describe 'deserialization' do
    let!(:operation) { FactoryGirl.create :operation }
    let!(:operation_as_json) { operation.as_json }
    let(:operation1) { Operation.new }

    before :each do
      operation1.from_json(operation_as_json.to_json)
    end

    it { expect(operation1.as_json).to eq(operation_as_json) }
  end

  describe 'translate_attributes' do
    let!(:experiment_case) {FactoryGirl.create :experiment_case}
    let!(:send_text) { Functions::SendText.new(selector_name: 'xpath',
                                                     selector_value: 'xpath',
                                                     value: 'Телефон -$phone_number(random, short_8)') }
    let!(:operation1) {FactoryGirl.create :operation,
                                          experiment_case: experiment_case,
                                          number: '1',
                                          operation_type: :check,
                                          function_name: 'send_text',
                                          operation_json: send_text.as_json.to_json}



    it { expect(operation1).to be_valid }

    it 'only print' do
      ap operation1.as_json(functions_translate: true)
    end
  end
end
