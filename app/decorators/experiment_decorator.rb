# frozen_string_literal: true

# Декоратор для Experiment
class ExperimentDecorator < Draper::Decorator
  delegate_all

  FIELD_NAME_VALUES_RELATIONS = { state: Experiment::STATE_VALUES }.freeze
  SIZE_TASK_LIST = 5

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def self.options_for_select_type(field_name)
    FIELD_NAME_VALUES_RELATIONS[field_name].map { |value| [human_attribute_value(field_name, value), value] }
  end

  def self.options_for_select_user(current_ability)
    User.accessible_by(current_ability).sort_by(&:email).map { |user| [user.to_s, user.id] }
  end

  def self.options_for_select_project(current_ability)
    Project.accessible_by(current_ability).map { |project| [project.name, project.id] }
  end

  def self.options_for_select_category(current_ability)
    Tag.accessible_by(current_ability).category.sort_by(&:title).map { |category| [category.name, category.title] }
  end

  def last_test_task(user_id)
    @last_test_task ||= object.test_tasks.by_user_id(user_id).completed.descendant_sort.first
  end

  def last_test_tasks(user_id)
    object.test_tasks.by_user_id(user_id).completed.descendant_sort.limit(SIZE_TASK_LIST)
  end

  def started_test_tasks(user_id)
    object.test_tasks.by_user_id(user_id).state(:started).limit(SIZE_TASK_LIST)
  end
end
