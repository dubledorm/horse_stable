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

  def attributes=(hash)
    hash.each do |key, value|
      if key.in?(Operation::OPERATION_TYPES)
        operation_type = key
        value.each do |operation_number, operation_hash|
          operation = self.operations.build
          operation.from_json({ operation_type: operation_type,
                                number: operation_number,
                                function_name: operation_hash['do'] }.to_json)
          function = Functions::Factory.build!(operation_hash['do'])
          function.attributes= operation_hash
          operation.operation_json = function.as_json.to_json
        end
      else
        send("#{key}=", value)
      end
    end
  end
end
