require 'rails_helper'

RSpec.describe Functions::SubScript do

  context 'wrong_arguments' do
    it { expect(described_class.new(do: 'sub_script')).to_not be_valid }
    it { expect(described_class.new(do: 'sub_script')).to_not be_valid }
  end

  context 'to_json' do
    let!(:experiment_with_operations) { FactoryGirl.create :experiment_with_operations }
    let!(:sub_script) { described_class.new(do: 'sub_script', script_id: experiment_with_operations.id) }

    it { expect(sub_script).to be_valid }
    it { expect(sub_script.script_json).to eq(experiment_with_operations.as_json) }
  end
end