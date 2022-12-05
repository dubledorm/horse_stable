# frozen_string_literal: true
# encoding: utf-8

module Front
  class ExperimentTestEnvironmentsController < Front::BaseController

    def create
      experiment_test_environment = ExperimentTestEnvironment.new(experiment_test_environment_params
                                                                    .merge(experiment_id: params
                                                                                            .required(:experiment_id)))

      unless experiment_test_environment.valid?
        raise ActionController::BadRequest, experiment_test_environment.errors.full_messages.join(', ')
      end

      experiment_test_environment.save!
      render json: experiment_test_environment.to_json, status: 200
    end

    # Возвращает список присоединённых к эксперименту environments
    def index
      experiment = get_experiment
      render json: ExperimentTestEnvironmentsCollectionDecorator
        .decorate(experiment.experiment_test_environments).to_json
    end


    # Обновить коллекцию значение переменных
    def update_variables
      experiment_test_environment = get_experiment_test_environment
      experiment_test_environment.environment_variables.clear
      params[:experiment_test_environment][:environment_variables].values.each do |variable|
        next if variable.keys.first == ''

        experiment_test_environment.environment_variables << EnvironmentVariable.new(key: variable[:key],
                                                                                     value: variable[:value])
      end
      experiment_test_environment.save
    end


    private

    def get_experiment_test_environment
      ExperimentTestEnvironment.find(params.required(:experiment_test_environment).required(:id))
    end

    def experiment_test_environment_params
      params.required(:experiment_test_environment).permit(:test_environment_id, :environment_variables)
    end

    def get_experiment
      Experiment.find(params.required(:experiment_id))
    end
  end
end
