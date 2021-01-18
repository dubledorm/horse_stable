module Functions
  class Scroll < Base
    DIRECTION_VALUES = %w(up down)

    attr_accessor :value, :direction
    validates :value, numericality: { only_integer: true }, allow_blank: false
    validates :direction, inclusion: { in: DIRECTION_VALUES,
                                       message: "Поле direction может содержать значения: #{DIRECTION_VALUES.map{ |item| item.to_s }.join(', ')}. %{value} это не корректное значение" }

    def self.attribute_hints
      super.merge({ 'value' => self.i18n_translate_path('value_hint'),
                                'direction' =>  self.i18n_translate_path('direction_hint') })
    end

    def self.attribute_values
      super.merge({ direction: DIRECTION_VALUES.sort })
    end
    protected

    def attributes
      super.merge( 'value' => self.value,
                   'direction' => self.direction )
    end
  end
end