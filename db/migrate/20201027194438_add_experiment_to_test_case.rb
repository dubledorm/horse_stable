class AddExperimentToTestCase < ActiveRecord::Migration[6.0]
  def change
    add_reference :test_cases, :experiment, null: false, foreign_key: true
  end
end
