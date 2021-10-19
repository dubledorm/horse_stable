module Functions
  class AlertControl < Base
    SWITCH_VALUES = %w(accept dismiss)

    attr_accessor :value
    validates :value, inclusion: { in: SWITCH_VALUES,
                             message: "Поле Действие может содержать значения: #{SWITCH_VALUES.map{ |item| item.to_s }.join(', ')}. %{value} это не корректное значение" }

    def self.attribute_values
      super.merge({ value: %w(accept dismiss).sort
                  })
    end


    def self.attribute_hints
      super.merge({ 'value' => self.i18n_translate_path('value_hint') })
    end

    protected

    def attributes
      super.merge( 'value' => self.value )
    end
  end
end