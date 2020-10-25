class CreateTestTask < ActiveRecord::Migration[6.0]
  def change
    create_table :test_tasks do |t|
      t.text :test_setting_json, null: false
      t.integer :duration
      t.datetime :start_time
      t.string :result_kod
      t.text :result_values_json

      t.timestamps
    end

    add_index :test_tasks, :start_time
    add_index :test_tasks, :result_kod
  end
end
