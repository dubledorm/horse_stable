class TestCase < ApplicationRecord
  # Класс, для сохранения шагов теста
  # Содержит элементарные операции - operation

  belongs_to :user
  belongs_to :experiment
  has_many :operations

  validates :human_name, presence: :true
end
