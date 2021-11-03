module Functions
  class SetVariable < Base

    attr_accessor :value, :variable_name, :storage_output
    validates :variable_name, :value, presence: true

    def self.attribute_hints
      super.merge({ 'variable_name' => self.i18n_translate_path('variable_name_hint'),
                    'value' => self.i18n_translate_path('value_hint'),
                    'storage_output' => self.i18n_translate_path('storage_output_hint')
                  })
    end

    # Порядок вывода атрибутов на форме
    def self.attribute_orders
      [:variable_name,
       :value,
       :storage_output
      ]
    end

    def self.attribute_values
      super.merge({ storage_output: %w[true false].sort
                  })
    end

    protected

    def attributes
      super.merge('variable_name' => self.variable_name,
                  'value' => self.value,
                  'storage_output' => self.storage_output || false)
    end
  end
end