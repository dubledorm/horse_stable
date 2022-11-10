# frozen_string_literal: true

# Декоратор для TestTask
class TestTaskDecorator < Draper::Decorator
  delegate_all

  FIELD_NAME_VALUES_RELATIONS = { result_kod: TestTask::RESULT_KOD_VALUES, state: TestTask::STATE_VALUES }.freeze

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def self.options_for_select_type(field_name)
    FIELD_NAME_VALUES_RELATIONS[field_name].map { |value| [human_attribute_value(field_name, value), value] }
  end

  def self.options_for_select_user
    User.all.map { |user| [user.to_s, user.id] }
  end

  def state
    object.human_attribute_value(:state)
  end

  def name
    object.experiment.human_name
  end

  def result_kod
    object.human_attribute_value(:result_kod)
  end
end
