class CreateEnvironmentVariable < ActiveRecord::Migration[6.0]
  def change
    create_table :environment_variables do |t|
      t.string :key
      t.string :value
      t.references :experiment_test_environment, null: false, foreign_key: true

      t.timestamps
    end
    add_index :environment_variables, %i[key experiment_test_environment_id], name: :key_for_environment_index
  end
end
