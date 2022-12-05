# frozen_string_literal: true

module Functions
  class Validate < BaseSelector

    attr_accessor :attribute, :value, :strictly

    validates :attribute, :value, presence: true

    def self.attribute_hints
      super.merge({ 'value' => i18n_translate_path('value_hint'),
                    'attribute' => i18n_translate_path('attribute_hint'),
                    'strictly' => i18n_translate_path('strictly_hint') })
    end

    # Порядок вывода атрибутов на форме
    def self.attribute_orders
      [%i[selector_name selector_value],
       %i[attribute value strictly]]
    end

    def self.attribute_values
      super.merge({ attribute: %w[visible text value displayed enabled hash hover selected size style tag_name
                                  class].sort,
                    strictly: %w[true false] })
    end

    protected

    def attributes
      super.merge('attribute' => attribute,
                  'value' => value,
                  'strictly' => strictly)
    end
  end
end
