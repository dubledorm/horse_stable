require 'rails_helper'

RSpec.describe Substitutions::PhoneNumber do

  describe 'constructor' do
    it { expect(described_class.new).to be_valid }
    it { expect(described_class.new('list', 'free')).to be_valid }
    it { expect(described_class.new('list', 'spaces_8').sequence).to eq('list') }
    it { expect(described_class.new('list', 'spaces_8').format).to eq('spaces_8') }
    it { expect(described_class.new('list', 'spaces_8').format).to eq('spaces_8') }
    it { expect(described_class.new.human_name).to eq('phone_number') }

    it { expect{described_class.new('list', 'free', 'wrong argument')}.to raise_error(ArgumentError) }
    it { expect{described_class.new('list', 'free', 'wrong argument', 'wrong argument')}.to raise_error(ArgumentError) }
  end

  describe 'calculate' do
    context 'format = strict' do
      let!(:phone_number) { described_class.new('random', 'short_8') }

      it { expect(phone_number.calculate =~ /\d{7}/).to be_truthy }
    end
  end
end