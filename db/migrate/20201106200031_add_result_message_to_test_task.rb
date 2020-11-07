class AddResultMessageToTestTask < ActiveRecord::Migration[6.0]
  def change
    add_reference :test_tasks, :operation, null: true, foreign_key: true
    add_column :test_tasks, :result_message, :string
  end
end
