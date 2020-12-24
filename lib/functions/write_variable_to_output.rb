module Functions
  class WriteVariableToOutput < Base

    attr_accessor :variable_name, :save_as
    validates :variable_name, :save_as, presence: true

    def self.attribute_hints
      super.merge({ 'variable_name' => self.i18n_translate_path('variable_name_hint'),
                    'save_as' => self.i18n_translate_path('save_as_hint'),
                  })
    end

    # Порядок вывода атрибутов на форме
    def self.attribute_orders
      [:variable_name,
       :save_as
      ]
    end

    protected

    def attributes
      super.merge('variable_name' => self.variable_name,
                  'save_as' => self.save_as)
    end
  end
end