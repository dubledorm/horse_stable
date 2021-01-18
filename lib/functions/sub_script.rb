module Functions
  class SubScript < Base

    attr_accessor :script_id
    validates :script_id, numericality: { only_integer: true }, allow_blank: false

    def self.attribute_hints
      super.merge({ 'script_id' => self.i18n_translate_path('script_id_hint') })
    end

    protected

    def attributes
      super.merge( 'script_id' => self.script_id )
    end
  end
end