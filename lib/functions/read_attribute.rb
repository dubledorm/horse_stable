module Functions
  class ReadAttribute < BaseSelector

    attr_accessor :attribute_name, :save_as

    def self.attribute_values
      super.merge({ attribute_name: %w[text value displayed enabled hash hover selected size style tag_name].sort
                  })
    end

    # Порядок вывода атрибутов на форме
    def self.attribute_orders
      [[:selector_name, :selector_value],
       :attribute_name,
       :save_as
      ]
    end

    def self.attribute_hints
      super.merge({ 'attribute_name' => self.i18n_translate_path('attribute_name_hint'),
                    'save_as' => self.i18n_translate_path('save_as_hint') })
    end

    protected

    def attributes
      super.merge('attribute_name' => self.attribute_name,
                  'save_as' => self.save_as)
    end
  end
end