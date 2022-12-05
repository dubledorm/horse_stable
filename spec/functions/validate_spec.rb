# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Functions::Validate do

  context 'wrong_arguments' do
    it { expect(described_class.new({})).to_not be_valid }
    it { expect(described_class.new(selector: { xpath: '//fieldset[17]/button[2]' })).to_not be_valid }
    it { expect(described_class.new(do: 'validate')).to_not be_valid }

    it 'print only' do
      function = described_class.new(do: 'validate')
      function.valid?
      ap function.errors.full_messages
    end
  end

  context 'truth arguments' do
    let!(:select_attributes) { { selector: { xpath: '//fieldset[17]/button[2]' }, attribute: 'text', value: '123', do: 'validate' } }
    let!(:selector_name_attributes) do
      { selector_name: 'xpath',
        selector_value: '//fieldset[17]/button[2]',
        attribute: 'text', value: '123',
        do: 'validate' }
    end
    let!(:empty_value_attributes) { { selector_name: 'xpath', do: 'validate' } }
    let!(:validate) { described_class.new }
    let!(:validate1) { described_class.new(selector_name_attributes) }


    it 'select_attributes' do
      validate.attributes = select_attributes
      expect(validate).to be_valid
    end

    it 'selector_name_attributes' do
      validate.attributes = selector_name_attributes
      expect(validate).to be_valid
    end

    it { expect(validate1).to be_valid }
  end
end
