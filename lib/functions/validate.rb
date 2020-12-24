module Functions
  class Validate < BaseSelector

    attr_accessor :attribute, :value
    validates :attribute, :value, presence: true

    def self.attribute_hints
      super.merge({ 'value' => self.i18n_translate_path('value_hint'),
                    'attribute' => self.i18n_translate_path('attribute_hint'),
                  })
    end

    # Порядок вывода атрибутов на форме
    def self.attribute_orders
      [[:selector_name, :selector_value],
       [:attribute, :value]
      ]
    end

    def self.attribute_values
      super.merge({ attribute: %w[visible].sort
                  })
    end


    protected

    def attributes
      super.merge( 'attribute' => self.attribute,
                   'value' => self.value)
    end
  end
end