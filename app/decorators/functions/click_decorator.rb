# frozen_string_literal: true

module Functions
  # Декоратор для Base
  class ClickDecorator < Functions::BaseSelectorDecorator
    delegate_all

  end
end
