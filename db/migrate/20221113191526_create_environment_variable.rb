class CreateEnvironmentVariable < ActiveRecord::Migration[6.0]
  def change
    create_table :environment_variables do |t|
      t.references :test_environment, null: false, foreign_key: true
      t.string :key
      t.string :value

      t.timestamps
    end

    add_index :environment_variables, %i[key test_environment_id]
  end
end
