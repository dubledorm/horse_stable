# frozen_string_literal: true

# Связка эксперимента с группой.
class ExperimentToUserGroup < ApplicationRecord
  belongs_to :experiment
  belongs_to :user_group
end
