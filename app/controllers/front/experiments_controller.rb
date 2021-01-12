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
      url_screen_shot = ''
      url_screen_shot_preview = ''
      last_test_task = experiment.last_test_task(params.required(:user_id))
      if last_test_task&.failed_screen_shot&.attached?
        url_screen_shot = url_for(last_test_task.failed_screen_shot)
        url_screen_shot_preview = url_for(last_test_task.failed_screen_shot.variant(resize_to_limit: [600, 600]))
      end
      render json: { id: last_test_task&.id,
                     start_time: last_test_task&.start_time&.to_s,
                     result_kod: last_test_task&.result_kod,
                     url_screen_shot: url_screen_shot,
                     url_screen_shot_preview: url_screen_shot_preview,
                     translated_result_kod: last_test_task&.human_attribute_value(:result_kod),
                     result_values_json: last_test_task&.result_values_json ? JSON.parse(last_test_task.result_values_json) : {},
                     result_message: last_test_task&.result_message,
                     experiment_case_id: last_test_task_experiment_case(last_test_task),
                     duration: last_test_task&.duration }
    end

    # Возвращает списиок последних задач в очереди
    def experiment_history_list
      experiment = get_experiment
      render json: { history_list: by_user(experiment) }
    end

    private

    def last_test_task_experiment_case(last_test_task)
      return unless last_test_task
      return unless last_test_task.result_kod == 'interrupted'
      return last_test_task.operation&.experiment_case_id
    end

    def get_experiment
      Experiment.find(params.required(:id))
    end

    def by_state_and_user(experiment, state)
      experiment
        .test_tasks.state(state)
        .by_user_id(params.required(:user_id))
        .map { |test_task| { id: test_task.id, start_time: test_task.start_time.to_s } }
    end

    def by_user(experiment)
      experiment
        .test_tasks
        .by_user_id(params.required(:user_id))
        .descendant_sort.limit(5)
        .map do |test_task| { id: test_task.id,
                              start_time: test_task.start_time.to_s,
                              state: test_task.human_attribute_value(:state),
                              result_kod: test_task.result_kod,
                              translated_result_kod: test_task.human_attribute_value(:result_kod) }
        end
    end
  end
end
