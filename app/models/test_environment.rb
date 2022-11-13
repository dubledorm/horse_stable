# frozen_string_literal: true

# Тествовое окружение (dev, stage, prod ... и ещё любые другие). Объединяет переменные
class TestEnvironment < ApplicationRecord

  validates :name, presence: true
  validates :name, uniqueness: { scope: :project }

  belongs_to :project
  has_many :environment_variables

  def to_s
    name
  end
end
