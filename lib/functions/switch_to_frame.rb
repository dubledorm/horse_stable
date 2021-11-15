require_relative 'base.rb'

module Functions
  class SwitchToFrame < Base
    ALLOW_VALUES = %w[false true].freeze

    attr_accessor :value, :to_default_frame
    validates :to_default_frame, inclusion: { in: ALLOW_VALUES, message: "%{value} is not a valid to_default_frame" }, allow_blank: true

    def self.attribute_hints
      super.merge({ 'value' => self.i18n_translate_path('value_hint'),
                    'to_default_frame' => self.i18n_translate_path('to_default_frame_hint') })
    end

    def self.attribute_values
      super.merge({ to_default_frame: ALLOW_VALUES.sort
                  })
    end

    protected

    def attributes
      super.merge( 'value' => self.value.strip.present? ? self.value.strip : '0',
                   'to_default_frame' => self.to_default_frame)
    end
  end
end