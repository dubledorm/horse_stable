# frozen_string_literal: true

module Functions
  # Декоратор для HttpRequest
  class HttpRequestDecorator < Draper::Decorator
    include Rails.application.routes.url_helpers
    delegate_all

    def to_html
      h.content_tag(:div, class: 'row') do
        "#{request_type.upcase} #{url}"
      end
    end
  end
end
