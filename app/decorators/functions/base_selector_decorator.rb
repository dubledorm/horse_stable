# frozen_string_literal: true

module Functions
  # Декоратор для Base
  class BaseSelectorDecorator < Functions::BaseDecorator
    delegate_all

    def to_html
      h.content_tag(:div, class: 'row truncate') do
        h.content_tag(:i, "#{selector_name}: ") + selector_value.to_s
      end
    end
  end
end
