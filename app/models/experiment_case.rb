class ExperimentCase < ApplicationRecord
  # Класс, для сохранения шагов теста
  # Содержит элементарные операции - operation

  belongs_to :user
  belongs_to :experiment
  has_many :operations

  validates :human_name, :number, presence: :true
  validates :number, uniqueness: { scope: [:experiment] }

  def clone
    attributes_hash = self.as_json
    attributes_hash[:user_id] = self.user_id
    attributes_hash[:experiment_id] = self.experiment_id
    attributes_hash[:human_name] = self.human_name
    attributes_hash[:human_description] = self.human_description
    attributes_hash[:number] = ExperimentCase::NextCaseNumber.find(self.experiment_id)

    experiment_case = ExperimentCase.new
    experiment_case.from_json(attributes_hash.to_json)
    experiment_case
  end

  def as_json(functions_translate: false)
    { human_name: self.human_name,
      check: operations_as_json(:check, functions_translate),
      do: operations_as_json(:do, functions_translate),
      next: operations_as_json(:next, functions_translate)
    }.stringify_keys
  end

  def operations_as_json(operation_type, functions_translate = false)
    operations.where(operation_type: operation_type).order(:number).inject({}) do |result, operation|
      result.merge({ "#{operation.number}" => operation.as_json(functions_translate: functions_translate) })
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
