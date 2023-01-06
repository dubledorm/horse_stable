# frozen_string_literal: true

module Functions
  # Декоратор для Base
  class SleepDecorator < Functions::BaseDecorator
    delegate_all

    def to_html
      h.content_tag(:div, class: 'row') do
        "#{value || 3} сек"
      end
    end
  end
end
