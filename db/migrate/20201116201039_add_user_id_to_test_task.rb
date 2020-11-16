class AddUserIdToTestTask < ActiveRecord::Migration[6.0]
  def change
    add_reference :test_tasks, :user, null: false, foreign_key: true
  end
end
