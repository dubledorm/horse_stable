# frozen_string_literal: true

# Проект, верхняя модель в иерархии
class Project < ApplicationRecord

  validates :name, presence: true

  has_many :experiments
  has_many :user_groups
end
