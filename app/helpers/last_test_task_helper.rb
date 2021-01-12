module LastTestTaskHelper

  def row_experiment_case_class(last_test_task, row_id)
    row_class = 'ordinal_experiment_case'
    row_class = 'failed_experiment_case' if last_test_task &&
      last_test_task.result_kod == 'interrupted' &&
      last_test_task.operation&.experiment_case_id == row_id
    row_class
  end

  def row_operation_class(last_test_task, row_id)
    row_class = 'ordinal_experiment_case'
    row_class = 'failed_experiment_case' if last_test_task &&
      last_test_task.result_kod == 'interrupted' &&
      last_test_task.operation_id == row_id
    row_class
  end
end