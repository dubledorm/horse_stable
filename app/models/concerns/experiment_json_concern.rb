
# Модуль с функциями для сериализации
module ExperimentJsonConcern
  extend ActiveSupport::Concern

  def as_json(functions_translate: false, delete_ids: false)
    result_hash = super.merge({ 'experiment_cases' => experiment_cases_as_json(functions_translate, delete_ids) })
    result_hash.delete('id') if delete_ids
    result_hash
  end

  def from_json(json)
    hash = JSON.parse(json)
    self.attributes = hash
  end

  def experiment_cases_as_json(functions_translate = false, delete_ids = false)
    experiment_cases.order(:number).inject([]) do |result, experiment_case|
      result << experiment_case.as_json(functions_translate: functions_translate, delete_ids: delete_ids)
    end
  end

  def clone
    attributes_hash = self.as_json(delete_ids: true)
    experiment = Experiment.new
    experiment.attributes = attributes_hash
    experiment
  end
end