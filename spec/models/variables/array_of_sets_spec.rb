require 'rails_helper'

RSpec.describe Variables::ArrayOfSets do
  describe 'model' do
    let(:json_example1) do
      "{\"sets\":[{\"set_id\":\"6969e943-5cb3-46ae-9ccb-08a132153608\",
\"human_set_name\":{\"set_id\":\"\",\"human_set_name\":\"34\",\"variables\":{\"0\":{\"key\":\"1\",\"variable_name\":
\"234\",\"variable_value\":\"23424\"}}},\"variables\":{}}],\"active_set_id\":null}"
    end


    it { expect(described_class.new({})).to be_valid }
    it { expect(described_class.new({}).sets).to_not be_nil }
    it { expect(described_class.new({active_set_id: 'id', sets: [{set_id: 'id', human_set_name: 'name'}]})).to be_valid }
    it { expect(described_class.new({active_set_id: 'id', sets: [{set_id: 'id1', human_set_name: 'name1', variables: {var1: 'val11', var2: 'val12'}},
                                                                          {set_id: 'id2', human_set_name: 'name2', variables: {var1: 'val21', var2: 'val22'}}]})).to be_valid }
    it { expect(described_class.new(JSON.parse(json_example1))).to be_valid }
  end

  describe 'attributes' do
    let(:array_of_sets) { described_class.new({active_set_id: 'id', sets: [{set_id: 'id1', human_set_name: 'name1', variables: {var1: 'val11', var2: 'val12'}},
                                                                                    {set_id: 'id2', human_set_name: 'name2', variables: {var1: 'val21', var2: 'val22'}}]}) }

    it { expect(array_of_sets.active_set_id).to eq('id') }
    it { expect(array_of_sets.sets[0].set_id).to eq('id1') }
    it { expect(array_of_sets.sets[1].set_id).to eq('id2') }
    it { expect(array_of_sets.sets[1].human_set_name).to eq('name2') }
    it { expect(array_of_sets.sets[1].variables['var2']).to eq('val22') }
    it { expect(array_of_sets.sets[0].variables['var1']).to eq('val11') }
  end

  describe 'to_json' do
    let(:array_of_sets) { described_class.new({active_set_id: 'id', sets: [{set_id: 'id1', human_set_name: 'name1', variables: {var1: 'val11', var2: 'val12'}},
                                                                           {set_id: 'id2', human_set_name: 'name2', variables: {var1: 'val21', var2: 'val22'}}]}) }
    it { expect(array_of_sets.to_json).to eq("{\"sets\":[{\"set_id\":\"id1\",\"human_set_name\":\"name1\",\"variables\":{\"var1\":\"val11\",\"var2\":\"val12\"}},{\"set_id\":\"id2\",\"human_set_name\":\"name2\",\"variables\":{\"var1\":\"val21\",\"var2\":\"val22\"}}],\"active_set_id\":\"id\"}") }
  end

  describe 'from_json' do
    let(:array_of_sets) { described_class.new({active_set_id: 'id', sets: [{set_id: 'id1', human_set_name: 'name1', variables: {var1: 'val11', var2: 'val12'}},
                                                                           {set_id: 'id2', human_set_name: 'name2', variables: {var1: 'val21', var2: 'val22'}}]}) }
    let(:json_str) { array_of_sets.to_json }
    let(:new_array_of_sets) { described_class.new(JSON.parse(json_str)) }

    it { expect(new_array_of_sets.active_set_id).to eq('id') }
    it { expect(new_array_of_sets.sets[0].set_id).to eq('id1') }
    it { expect(new_array_of_sets.sets[1].set_id).to eq('id2') }
    it { expect(new_array_of_sets.sets[1].human_set_name).to eq('name2') }
    it { expect(new_array_of_sets.sets[1].variables['var2']).to eq('val22') }
    it { expect(new_array_of_sets.sets[0].variables['var1']).to eq('val11') }
  end
end