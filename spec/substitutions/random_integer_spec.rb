require 'rails_helper'

RSpec.describe Substitutions::RandomInteger do

  describe 'constructor' do
    it { expect(described_class.new).to be_valid }
    it { expect(described_class.new(10, 20)).to be_valid }
    it { expect(described_class.new(10, 20).min_value).to eq(10) }
    it { expect(described_class.new(10, 20).max_value).to eq(20) }
    it { expect(described_class.new(20, 10)).to_not be_valid }
    it { expect(described_class.new(20, 20)).to_not be_valid }

    it { expect(described_class.new('10', '20')).to be_valid }
    it { expect(described_class.new('10', '20').min_value).to eq(10) }
    it { expect(described_class.new('10', '20').max_value).to eq(20) }
    it { expect(described_class.new('20', '10')).to_not be_valid }
    it { expect(described_class.new('20', '20')).to_not be_valid }

  end

  describe 'calculate' do
    context '1-2' do
      let!(:random_integer) { described_class.new('10','10') }

      it { expect(random_integer.calculate).to eq(10) }
    end
  end
end