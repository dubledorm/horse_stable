class DropTestCaseRelationsFromOperation < ActiveRecord::Migration[6.0]
  def change
    remove_reference :operations, :test_case
    add_reference :operations, :experiment_case
  end
end
