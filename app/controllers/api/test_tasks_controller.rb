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
                          finished_time: Time.now,
                          result_message: test_task.require(:errors)[:message] )
        if test_task.require(:errors)[:failed_screen_shot].present?
          Tempfile.create(['', 'png'], binmode: true) do |f|
            f << Base64.decode64(test_task.require(:errors)[:failed_screen_shot])
            f.rewind
            @resource.failed_screen_shot.attach(io: f, filename: 'file.png')
          end
        end
        ExperimentChannel.broadcast_to 'ExperimentChannel', { experiment_id: @resource.experiment_id }
      end
    end

    def get_task
      Rails.logger.debug('get_task')

      task = TestTask::FindNewJob.find
      if task.present?
        result = { job_status: :job,
                   job_id: task.id,
                   environment_json: task.environment_json,
                   test: JSON.parse(task.test_setting_json).symbolize_keys }
        task.update!(state: 'started', start_time: Time.now)
        ExperimentChannel.broadcast_to 'ExperimentChannel', { experiment_id: task.experiment_id }
      else
        result = { job_status: :idle }.to_json
      end

      render json: result, status: 200
    end
  end
end
