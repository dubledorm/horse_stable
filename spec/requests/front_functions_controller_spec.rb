# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Front::FunctionsController, type: :request do

  describe 'get_parameters#' do

    context 'for read_attributes' do
      let(:subject) { get(front_functions_get_parameters_path(name: 'read_attribute')) }

      before :each do
        subject
      end

      it { expect(response).to have_http_status(200) }
      it { expect(JSON.parse(response.body)['attributes'].keys).to eq(%w[attribute_name save_as selector_name selector_value]) }
      it { expect(JSON.parse(response.body)['attribute_values']).to eq({ 'attribute_name' => %w[displayed enabled hash hover selected size style tag_name text value],
                                                                         'selector_name' => %w[class_name id link_text name partial_link_text tag_name xpath] }) }
      it { expect(JSON.parse(response.body)['attribute_orders']).to eq([%w[selector_name selector_value],'attribute_name','save_as'])}
    end

    context 'bad attributes' do
      let(:subject) { get(front_functions_get_parameters_path(name: 'bad_bad_bad')) }

      before :each do
        subject
      end

      it { expect(response).to have_http_status(500) }
      it { expect(JSON.parse(response.body)['message']).to eq('Неизвестное имя функции bad_bad_bad') }

    end
  end
end