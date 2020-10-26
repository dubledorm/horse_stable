require 'rails_helper'

RSpec.describe Functions::Click do

  context 'wrong_arguments' do
    it { expect(described_class.new({})).to_not be_valid }
    it { expect(described_class.new(selector: { xpath: '//fieldset[17]/button[2]' })).to_not be_valid }
    it { expect(described_class.new(function_name: 'click')).to_not be_valid }

    it 'print only' do
      function = described_class.new(function_name: 'click')
      function.valid?
      ap function.errors.full_messages
    end
  end

  context 'truth arguments' do
    let!(:click) { described_class.new( selector: { xpath: '//fieldset[17]/button[2]' },
                                              function_name: 'click' ) }

    it { expect(click).to be_valid }
  end

  context 'to_json' do
    let!(:attr) { { human_name: 'Клик',
                    human_description: 'Описание',
                    function_name: 'click',
                    selector: { xpath: '//fieldset[17]/button[2]' }
    } }

    let!(:click) { described_class.new(attr) }

    it { expect(click.to_json).to eq(attr.to_json) }
  end

  context 'from_json' do
    let!(:attr) { { human_name: 'Клик',
                    human_description: 'Описание',
                    function_name: 'click',
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
    it { expect(described_class.human_attribute_name('function_name')).to eq('Имя') }
  end
end