# frozen_string_literal: true

# Проект, верхняя модель в иерархии
class Project < ApplicationRecord

  validates :name, presence: true

  has_many :experiments
  has_many :user_groups
  has_many :project_to_users
  has_many :users, through: :project_to_users
  accepts_nested_attributes_for :project_to_users, allow_destroy: true
end
