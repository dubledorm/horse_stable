class Operation
  class NextOperationNumber

    def self.find(experiment_case_id, operation_type)
      new_number = Operation.where(experiment_case_id: experiment_case_id, operation_type: operation_type).maximum(:number) || 0
      new_number + 1
    end
  end
end