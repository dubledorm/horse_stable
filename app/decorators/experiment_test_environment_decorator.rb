# frozen_string_literal: true

# Декоратор для Experiment
class ExperimentTestEnvironmentDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def name
    object.test_environment.to_s
  end

  def to_s
    name
  end

  def to_json(*_args)
    super(include: :environment_variables, methods: [:name])
  end
end
