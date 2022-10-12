module Functions
  class WaitElement < BaseSelector

    attr_accessor :delay, :need_refresh, :refresh_period_in_sec
    validates :delay, numericality: { only_integer: true }, presence: true
    validates :refresh_period_in_sec, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true

    # Порядок вывода атрибутов на форме
    def self.attribute_orders
      [[:selector_name, :selector_value],
       :delay,
       [:need_refresh, :refresh_period_in_sec]
      ]
    end

    def self.attribute_hints
      super.merge({ 'delay' => self.i18n_translate_path('delay_hint'),
                                'need_refresh' => self.i18n_translate_path('need_refresh_hint'),
                                'refresh_period_in_sec' => self.i18n_translate_path('refresh_period_in_sec_hint')})
    end

    def self.attribute_values
      super.merge({ need_refresh: %w[true false].sort
                  })
    end

    protected

    def attributes
      super.merge('delay' => self.delay,
                  'need_refresh' => self.need_refresh,
                  'refresh_period_in_sec' => self.refresh_period_in_sec)
    end
  end
end