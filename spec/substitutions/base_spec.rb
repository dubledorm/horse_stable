require 'rails_helper'

RSpec.describe Substitutions::Base do

  context 'human_name' do
    it { expect(described_class.new).to be_valid }
    it { expect(described_class.new.human_name).to eq('base') }
  end

  context 'translate_attributes' do
    let(:base_fnc) { Functions::Base.new(do: 'phone: $phone_number(random, short_7)')}

    it 'only print' do
      ap base_fnc.translate_attributes
    end

    it { expect(base_fnc.translate_attributes['do'] =~ /^phone: \+7\d{10}$/).to be_truthy }
  end
end