module Api
  class TestTasksController < Api::BaseController

    def update
      super do
        test_task = params.require('test_task')
        @resource.update!(state: 'completed',
                          result_kod: test_task.require('result_kod'),
                          result_values_json: test_task['output_values']&.to_json,
                          duration: test_task.require('statistic')['duration'],
                          operation_id: test_task.require(:errors)[:operation_id],
                          result_message: test_task.require(:errors)[:message] )
        ExperimentChannel.broadcast_to 'ExperimentChannel', { experiment_id: @resource.experiment_id }
      end
    end

    def get_task
      Rails.logger.debug('get_task')

      task = TestTask::FindNewJob.find

      if task.present?
        result = { job_status: :job,
                   job_id: task.id,
                   test: JSON.parse(task.test_setting_json).symbolize_keys }
        task.update!(state: 'started')
        ExperimentChannel.broadcast_to 'ExperimentChannel', { experiment_id: task.experiment_id }
      else
        result = { job_status: :idle }.to_json
      end

      render json: result, status: 200
    end
  end
end
