module Front
  class ExperimentsController < Front::BaseController

    # Возвращает списиок запущенных на данный момент экспериментов
    def experiment_current_state
      experiment = get_experiment
      render json: { started_tasks: by_state_and_user(experiment, :started),
                     query_tasks: by_state_and_user(experiment, :new) }
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
