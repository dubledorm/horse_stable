class ExperimentCase < ApplicationRecord
  # Класс, для сохранения шагов теста
  # Содержит элементарные операции - operation

  belongs_to :user
  belongs_to :experiment
  has_many :operations

  validates :human_name, :number, presence: :true
  validates :number, uniqueness: { scope: [:experiment] }

  def as_json
    { check: operations_as_json(:check),
      do: operations_as_json(:do),
      next: operations_as_json(:next)
    }.stringify_keys
  end

  def operations_as_json(operation_type)
    operations.where(operation_type: operation_type).order(:number).inject({}) do |result, operation|
      result.merge({ "#{operation.number}" => operation.as_json })
    end.stringify_keys
  end
end
