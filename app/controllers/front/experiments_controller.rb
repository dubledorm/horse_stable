module Front
  class ExperimentsController < Front::BaseController

    # Возвращает списиок запущенных на данный момент экспериментов
    def experiment_current_state
      experiment = get_experiment
      render json: { started_tasks: by_state_and_user(experiment, :started),
                     query_tasks: by_state_and_user(experiment, :new) }
    end

    # Возвращает последний результат эксперимента
    def experiment_last_result
      experiment = get_experiment
      last_test_task = experiment.last_test_task(params.required(:user_id))
      render json: { id: last_test_task&.id,
                     start_time: last_test_task&.start_time&.to_s,
                     result_kod: last_test_task&.result_kod,
                     translated_result_kod: last_test_task&.human_attribute_value(:result_kod),
                     result_values_json: last_test_task&.result_values_json ? JSON.parse(last_test_task.result_values_json) : {},
                     result_message: last_test_task&.result_message,
                     duration: last_test_task&.duration }
    end

    private

    def get_experiment
      Experiment.find(params.required(:id))
    end

    def by_state_and_user(experiment, state)
      experiment
        .test_tasks.state(state)
        .by_user_id(params.required(:user_id))
        .map { |test_task| { id: test_task.id, start_time: test_task.start_time.to_s } }
    end
  end
end
