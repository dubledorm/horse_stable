class DropTestCase < ActiveRecord::Migration[6.0]
  def change
    rename_table :test_cases, :experiment_cases
  end
end
