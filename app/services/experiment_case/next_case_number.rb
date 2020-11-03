class ExperimentCase
  class NextCaseNumber

    def self.find(experiment_id)
      new_number = ExperimentCase.where(experiment_id: experiment_id).maximum(:number) || 0
      new_number + 1
    end
  end
end