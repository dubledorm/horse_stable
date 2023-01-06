# frozen_string_literal: true

module Functions
  # Декоратор для Base
  class WriteVariableToOutputDecorator < Draper::Decorator

    delegate_all

    def to_html
      h.content_tag(:div, class: 'row') do
        "#{variable_name} -> #{save_as}"
      end
    end
  end
end
