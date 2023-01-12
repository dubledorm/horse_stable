class AddDefaultEnvironmentToExperiment < ActiveRecord::Migration[6.0]
  def change
    add_reference :experiments, :default_test_environment, null: true, foreign_key: { to_table: :experiment_test_environments }
  end
end
