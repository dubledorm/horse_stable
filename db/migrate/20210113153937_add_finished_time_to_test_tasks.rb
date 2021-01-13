class AddFinishedTimeToTestTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :test_tasks, :plan_start_time, :datetime
    add_column :test_tasks, :finished_time, :datetime
  end
end
