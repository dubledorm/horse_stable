module Functions
  class IfExists < BaseSelector

    attr_accessor :delay
    validates :delay, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true

    def self.attribute_hints
      super.merge({ 'delay' => self.i18n_translate_path('delay_hint') })
    end

    # Порядок вывода атрибутов на форме
    def self.attribute_orders
      [[:selector_name, :selector_value],
       :delay
      ]
    end


    protected

    def attributes
      super.merge('delay' => self.delay)
    end
  end
end