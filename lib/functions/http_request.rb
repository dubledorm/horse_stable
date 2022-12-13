# frozen_string_literal: true

module Functions
  class HttpRequest < Base
    REQUEST_TYPE_VALUES = {get: 'get',
                           post: 'post',
                           patch: 'patch',
                           put: 'put',
                           delete: 'delete'}.freeze

    attr_accessor :url, :request_type, :request_header_json, :request_body,
                  :only_response_200, :result_selector_json, :response_status_variable

    validates :url, :request_type, presence: true
    validates :request_type, inclusion: { in: REQUEST_TYPE_VALUES.values }
    validates :url, format: { with: Regexp.new('\A(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#\[\]@!\$&\'\(\)\*\+,;=.]+\Z') }

    def self.attribute_hints
      super.merge({ 'url' => i18n_translate_path('url_hint'),
                    'request_type' => i18n_translate_path('request_type_hint'),
                    'request_header_json' => i18n_translate_path('request_header_json_hint'),
                    'request_body' => i18n_translate_path('request_body_hint'),
                    'result_selector_json' => i18n_translate_path('result_selector_json_hint'),
                    'only_response_200' => i18n_translate_path('only_response_200_hint'),
                    'response_status_variable' => i18n_translate_path('response_status_variable_hint') })
    end

    def self.attribute_values
      super.merge({ request_type: %w[get post put patch delete].sort,
                    only_response_200: %w[true false] })
    end

    # Порядок вывода атрибутов на форме
    def self.attribute_orders
      %i[url request_type request_header_json request_body only_response_200
         response_status_variable result_selector_json]
    end

    protected

    def attributes
      super.merge('url': url,
                  'request_type': request_type,
                  'request_header_json': request_header_json,
                  'request_body': request_body,
                  'result_selector_json': { 'first_postamat_id' => '/data/collection/[1]/id/' },
                  'only_response_200': only_response_200,
                  'response_status_variable': response_status_variable)
    end
  end
end
