module Functions
  class Sleep < Base

    attr_accessor :value
    validates :value, numericality: { only_integer: true }, allow_blank: true

    def self.attribute_hints
      super.merge({ 'value' => self.i18n_translate_path('value_hint') })
    end

    protected

    def attributes
      super.merge( 'value' => self.value )
    end
  end
end