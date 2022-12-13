# frozen_string_literal: true

# Декоратор для Operation
class OperationDecorator < Draper::Decorator
  delegate_all

  def function_name
    Functions::Factory.function_name_to_human(object.function_name)
  end

  def to_html
    function = Functions::Factory.build!(object.function_name, JSON.parse(object.operation_json || '{}'))
    function.decorate.to_html
  end
end
