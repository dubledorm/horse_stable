require 'rails_helper'

RSpec.describe Variables::SetOfVariables do
  describe 'model' do
    it { expect(described_class.new({})).to_not be_valid }
    it { expect(described_class.new({set_id: 'id', human_set_name: 'name'})).to be_valid }
    it { expect(described_class.new({set_id: 'id', human_set_name: 'name', variables: {var1: 'val1', var2: 'val2'}})).to be_valid }
  end

  describe 'attributes' do
    let(:set1) { Variables::SetOfVariables.new(set_id: 'id', human_set_name: 'name', variables: {var1: 'val1', var2: 'val2'}) }

    it { expect(set1.set_id).to eq('id') }
    it { expect(set1.human_set_name).to eq('name') }
    it { expect(set1.variables).to eq({var1: 'val1', var2: 'val2'}) }
    it { expect(set1.variables[:var2]).to eq('val2') }
  end

  describe 'to_json' do
    let(:set1) { Variables::SetOfVariables.new(set_id: 'id', human_set_name: 'name', variables: {var1: 'val1', var2: 'val2'}) }
    it { expect(set1.to_json).to eq("{\"set_id\":\"id\",\"human_set_name\":\"name\",\"variables\":{\"var1\":\"val1\",\"var2\":\"val2\"}}") }
  end

  describe 'from_json' do
    let(:set1) { Variables::SetOfVariables.new(set_id: 'id', human_set_name: 'name', variables: {var1: 'val1', var2: 'val2'}) }
    let(:json_str) { set1.to_json }
    let(:new_set) { Variables::SetOfVariables.new(JSON.parse(json_str)) }

    it { expect(new_set.set_id).to eq('id') }
    it { expect(new_set.human_set_name).to eq('name') }
    it { expect(new_set.variables).to eq({'var1' => 'val1', 'var2' => 'val2'}) }
    it { expect(new_set.variables['var2']).to eq('val2') }
  end
end