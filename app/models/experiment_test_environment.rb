# frozen_string_literal: true

# Валидатор, проверяет, что не подключено окружение от другово проекта
class ExperimentTestEnvironmentValidator < ActiveModel::Validator
  def validate(record)
    unless record.test_environment_project.id == record.experiment_project.id
      record.errors.add :test_environment, :unallowable_project
    end
  end
end

# Тестовое окружение для конкретного эксперимента
# Через ссылку на test_environment определяет название окружения и позволяет завести только те окружения,
# которые разрешены в проекте
class ExperimentTestEnvironment < ApplicationRecord
  belongs_to :test_environment
  belongs_to :experiment

  has_one :test_environment_project, class_name: 'Project', through: :test_environment, source: :project
  has_one :experiment_project, class_name: 'Project', through: :experiment, source: :project
  has_many :environment_variables, dependent: :destroy

  validates :test_environment, uniqueness: { scope: :experiment }
  validates_with ExperimentTestEnvironmentValidator
end
