require 'rails_helper'

RSpec.describe Substitutions::Calculate do

  context 'human_name' do
    it { expect{described_class.new}.to raise_error(ArgumentError) }
    it { expect{described_class.new('sum')}.to raise_error(ArgumentError) }
    it { expect(described_class.new('хрень', 'attr1')).to be_invalid }
    it { expect(described_class.new('sum', 'attr1')).to be_valid }
    it { expect(described_class.new('sum', 'attr1').human_name).to eq('calculate') }
  end

  context 'translate_attributes' do
    let(:base_fnc) { Functions::Base.new(do: '$calculate(sum, attr1, attr2, attr3, attr4)')}

    it 'only print' do
      ap base_fnc.translate_attributes
    end

    it { expect(base_fnc.translate_attributes['do']).to eq('$calculate(sum, attr1, attr2, attr3, attr4)') }
  end
end