# frozen_string_literal: true

require 'rails_helper'

class HttpRequestTest < Functions::HttpRequest
  def result_selector_as_json
    super
  end
end

RSpec.describe Functions::HttpRequest do

  context 'wrong_arguments' do
    it { expect(described_class.new({})).to_not be_valid }
    it { expect(described_class.new(do: 'http_request')).to_not be_valid }
    it {
      expect(described_class.new(url: 'http://127.0.0.1:3000', request_type: 'wrong',
                                 do: 'http_request')).to_not be_valid
    }
    it {
      expect(described_class.new(url: 'wrong', request_type: 'get',
                                 do: 'http_request')).to_not be_valid
    }


    it 'print only' do
      function = described_class.new(do: 'http_request')
      function.valid?
      ap function.errors.full_messages
    end
  end

  context 'truth arguments' do
    it {
      expect(described_class.new(url: 'http://127.0.0.1:3000',
                                 request_type: 'get', do: 'http_request')).to be_valid
    }
    it {
      expect(described_class.new(url: 'http://127.0.0.1',
                                 request_type: 'post', do: 'http_request')).to be_valid
    }
    it {
      expect(described_class.new(url: 'http://127.0.0.1:3000/function_name&param1=value1',
                                 request_type: 'get', do: 'http_request')).to be_valid
    }
    it {
      expect(described_class.new(url: 'http://127.0.0.1:3000',
                                 request_type: 'post', do: 'http_request')).to be_valid
    }
  end

  describe 'result_selector_as_json' do
    context 'when pair dose not exist' do
      it {
        expect(HttpRequestTest.new(url: 'http://127.0.0.1:3000',
                                   request_type: 'post', do: 'http_request',
                                   result_selector_json: '').result_selector_as_json).to eq({ })
      }
    end

    context 'when pair exists' do
      it {
        expect(HttpRequestTest.new(url: 'http://127.0.0.1:3000',
                                   request_type: 'post', do: 'http_request',
                                   result_selector_json: '[{"key":"first_postamat_id","value":"/data/collection/[0]/id"}]')
                              .result_selector_as_json).to eq({ 'first_postamat_id' => '/data/collection/[0]/id' })
      }

      it {
        expect(HttpRequestTest.new(url: 'http://127.0.0.1:3000',
                                   request_type: 'post', do: 'http_request',
                                   result_selector_json: '[{"key":"first_postamat_id","value":"/data/collection/[0]/id"},{"key":"second_postamat_id","value":"/data/collection/[1]/id"}]').result_selector_as_json).to eq({ 'first_postamat_id' => '/data/collection/[0]/id',
                                           'second_postamat_id' => '/data/collection/[1]/id' })
      }
    end
  end
end
