class CreateExperimentTestEnvironment < ActiveRecord::Migration[6.0]
  def change
    create_table :experiment_test_environments do |t|
      t.references :experiment, null: false, foreign_key: true
      t.references :test_environment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
