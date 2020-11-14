require 'rails_helper'

RSpec.describe Functions::Click do

  context 'wrong_arguments' do
    it { expect(described_class.new({})).to_not be_valid }
    it { expect(described_class.new(selector: { xpath: '//fieldset[17]/button[2]' })).to_not be_valid }
    it { expect(described_class.new(do: 'click')).to_not be_valid }

    it 'print only' do
      function = described_class.new(do: 'click')
      function.valid?
      ap function.errors.full_messages
    end
  end

  context 'truth arguments' do
    let!(:select_attributes) { { selector: { xpath: '//fieldset[17]/button[2]' }, do: 'click' } }
    let!(:selector_name_attributes) { { selector_name: 'xpath', selector_value: '//fieldset[17]/button[2]', do: 'click' } }
    let!(:empty_value_attributes) { { selector_name: 'xpath', do: 'click' } }
    let!(:click) { described_class.new }
    let!(:click1) { described_class.new(selector_name_attributes) }


    it 'select_attributes' do
      click.attributes = select_attributes
      expect(click).to be_valid
    end

    it 'selector_name_attributes' do
      click.attributes = selector_name_attributes
      expect(click).to be_valid
    end

    it 'empty_value_attributes' do
      click.attributes = empty_value_attributes
      expect(click).to be_valid
    end

    it { expect(click1).to be_valid }
  end

  context 'add_value' do
    let!(:attr) { { human_name: 'Клик',
                          human_description: 'Описание',
                          do: 'click',
                          selector_name: 'xpath'
                       } }

    let!(:click) { described_class.new(attr) }

    before :each do
      click.attributes={ selector_value: 'csdsadSADSA' }
    end

    it { expect(click).to be_valid }
    it { expect(click.selector_value).to eq('csdsadSADSA') }
  end

  context 'to_json' do
    let!(:attr) { { human_name: 'Клик',
                    human_description: 'Описание',
                    do: 'click',
                    selector: { xpath: '//fieldset[17]/button[2]' }
    } }

    let!(:click) { described_class.new(attr) }

    it { expect(click.to_json).to eq(attr.to_json) }
  end

  context 'from_json' do
    let!(:attr) { { human_name: 'Клик',
                          human_description: 'Описание',
                          do: 'click',
                          selector: { xpath: '//fieldset[17]/button[2]' }
                       } }
    let!(:click) { described_class.new }

    before :each do
      click.from_json(attr.to_json)
    end


    it { expect(click.human_name).to eq('Клик') }
    it { expect(click.to_json).to eq(attr.to_json) }
  end

  context 'translate attributes' do

    it { expect(described_class.human_attribute_name('selector')).to eq('Селектор') }
    it { expect(described_class.human_attribute_name('human_name')).to eq('Функция') }
    it { expect(described_class.human_attribute_name('human_description')).to eq('Описание') }
    it { expect(described_class.human_attribute_name('do')).to eq('Имя') }
  end
end