# frozen_string_literal: true

module Functions
  # Декоратор для Base
  class BaseDecorator < Draper::Decorator
    delegate_all

    def to_html
      object.as_json.symbolize_keys.except(:human_name, :human_description, :do).each do |item|
        h.content_tag(:div, class: 'row') do
          item
        end
      end
    end
  end
end
