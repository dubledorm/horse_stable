module Functions
  class SubScript < Base

    attr_accessor :script_id
    validates :script_id, numericality: { only_integer: true }, allow_blank: false

    attr_accessor :script_json # Здесь сохраняем скрипт для передачи на сторону webDriver

    def self.attribute_hints
      super.merge({ 'script_id' => self.i18n_translate_path('script_id_hint') })
    end

    def attributes=(hash)
      return unless hash
      super
      self.script_json = build_script_json
    end

    def short_attribute_names
      super.reject{ |name| name == 'script_json' }
    end

    protected

    def attributes
      super.merge( 'script_id' => self.script_id,
                   'script_json' => self.script_json )
    end

    private

    def build_script_json
      return nil unless self.script_id
      Experiment.find(self.script_id).as_json
    end
  end
end