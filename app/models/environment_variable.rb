# frozen_string_literal: true

# Переменная
class EnvironmentVariable < ApplicationRecord

  validates :key, :value, presence: true
  validates :key, uniqueness: { scope: :experiment_test_environment }

  belongs_to :experiment_test_environment
end
