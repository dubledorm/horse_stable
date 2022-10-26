# frozen_string_literal: true

# Связка пользователей с проектом. Также, содержит права пользователя
class ProjectToUser < ApplicationRecord
  include HumanAttributeValue

  ACCESS_RIGHT_VALUES = %w[developer tester].freeze

  validates :access_right, presence: true
  validates :access_right, inclusion: { in: ACCESS_RIGHT_VALUES }

  belongs_to :user
  belongs_to :project
end
