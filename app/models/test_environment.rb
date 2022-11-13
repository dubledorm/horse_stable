# frozen_string_literal: true

# Проект, верхняя модель в иерархии
class TestEnvironment < ApplicationRecord

  validates :name, presence: true
  validates :name, uniqueness: { scope: :project }

  belongs_to :project

  def to_s
    name
  end
end
