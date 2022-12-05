# frozen_string_literal: true

# Декоратор для Experiment
class ExperimentTestEnvironmentsCollectionDecorator < Draper::CollectionDecorator

  def to_json(*_args)
    object.map(&:decorate).to_json(include: :environment_variables, methods: [:name])
  end
end
