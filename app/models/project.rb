# frozen_string_literal: true

# Проект, верхняя модель в иерархии
class Project < ApplicationRecord

  validates :name, presence: true

  has_many :experiments
  has_many :user_groups
  has_many :project_to_users
  has_many :users, through: :project_to_users
  has_many :test_environments
  has_many :experiment_test_environments

  accepts_nested_attributes_for :project_to_users, allow_destroy: true
  accepts_nested_attributes_for :test_environments, allow_destroy: true

  def to_s
    name
  end
end
