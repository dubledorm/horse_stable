# frozen_string_literal: true

# Переменная
class EnvironmentVariable < ApplicationRecord

  validates :key, :value, presence: true
  validates :key, uniqueness: { scope: :test_environment }

  belongs_to :test_environment
end
