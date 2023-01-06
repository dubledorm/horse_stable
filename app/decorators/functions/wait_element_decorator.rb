# frozen_string_literal: true

module Functions
  # Декоратор для Base
  class WaitElementDecorator < Functions::BaseSelectorDecorator
    delegate_all

    def to_html
      super +
        h.content_tag(:div, class: 'row') do
          "#{I18n.t('wait')} #{delay} сек#{need_refresh == 'true' ? ", #{I18n.t('need_refresh')}" : ''}"
        end
    end
  end
end
