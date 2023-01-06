# frozen_string_literal: true

module Functions
  # Декоратор для Base
  class SendTextDecorator < Functions::BaseSelectorDecorator
    delegate_all

    def to_html
      super +
        h.content_tag(:div, class: 'row') do
          if value_from_storage.present?
            h.content_tag(:i, "#{I18n.t('from_variable')}: ") + value_from_storage.to_s
          else
            h.content_tag(:i, "#{I18n.t('text')}: ") + value.to_s
          end
        end
    end
  end
end
