module Functions
  class Connect < Base

    attr_accessor :value

    validates :value, presence: true

    def self.attribute_hints
      super.merge({ 'value' => i18n_translate_path('value_hint') })
    end

    protected

    def attributes
      super.merge('value' => self.value)
    end
  end
end
