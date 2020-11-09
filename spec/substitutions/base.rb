require 'rails_helper'

RSpec.describe Substitutions::Base do

  context 'human_name' do
    it { expect(described_class.new).to be_valid }
    it { expect(described_class.new.human_name).to eq('base') }
  end
end