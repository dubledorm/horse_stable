class ExperimentCase < ApplicationRecord
  # Класс, для сохранения шагов теста
  # Содержит элементарные операции - operation

  belongs_to :user
  belongs_to :experiment
  has_many :operations, dependent: :destroy

  validates :human_name, :number, presence: :true
  validates :number, uniqueness: { scope: [:experiment] }

  def clone
    attributes_hash = self.as_json(delete_ids: true)
    attributes_hash['id'] = nil
    attributes_hash['number'] = ExperimentCase::NextCaseNumber.find(self.experiment_id)
    %w[check do next].each do |section_name|
      attributes_hash[section_name].each{|operation| operation['id'] = nil}
    end
    experiment_case = ExperimentCase.new
    experiment_case.attributes = attributes_hash
    experiment_case

  end

  def as_json(functions_translate: false, delete_ids: false)
    result_hash = super.merge({ check: operations_as_json(:check, functions_translate, delete_ids),
                                do: operations_as_json(:do, functions_translate, delete_ids),
                                next: operations_as_json(:next, functions_translate, delete_ids)
                              }.stringify_keys)
    result_hash.delete('id') if delete_ids
    result_hash
  end

  def from_json(json)
    hash = JSON.parse(json)
    self.attributes = hash
  end

  def operations_as_json(operation_type, functions_translate = false, delete_ids = false)
    operations.where(operation_type: operation_type).order(:number).inject([]) do |result, operation|
      result << operation.as_json(functions_translate: functions_translate, delete_ids: delete_ids).stringify_keys
    end
  end

  def attributes=(hash)
    hash.each do |key, value|
      if key.in?(Operation::OPERATION_TYPES)
        # Обрабатываем массив операций
        value.each do |operation|
          new_operation = self.operations.build
          new_operation.from_json(operation.to_json)
        end
      else
        send("#{key}=", value)
      end
    end
  end
end
