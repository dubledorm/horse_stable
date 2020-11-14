require 'rails_helper'

RSpec.describe Functions::Factory do
  let!(:click_arguments) { { selector: { xpath: '//fieldset[17]/button[2]' } } }
  let!(:empty_arguments) { {} }


  context 'click' do
    it { expect(described_class.build!('click', click_arguments).class).to eq(Functions::Click) }
  end

  context 'wrong_arguments' do
    it { expect{ described_class.build!('unknown', click_arguments) }.to \
    raise_error(an_instance_of(Functions::Factory::FunctionBuildError).and having_attributes(message: 'Неизвестное имя функции unknown')) }
  end
end