# frozen_string_literal: true

# Связка пользователей с группой. Также, содержит права пользователя
class UserToUserGroup < ApplicationRecord
  include HumanAttributeValue

  ACCESS_RIGHT_VALUES = %w[user manager].freeze

  validates :access_right, presence: true
  validates :access_right, inclusion: { in: ACCESS_RIGHT_VALUES }

  belongs_to :user
  belongs_to :user_group
end
