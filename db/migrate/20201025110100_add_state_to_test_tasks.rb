class AddStateToTestTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :test_tasks, :state, :string

    add_index :test_tasks, :state
  end
end
