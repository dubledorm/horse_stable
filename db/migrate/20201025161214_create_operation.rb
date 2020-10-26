class CreateOperation < ActiveRecord::Migration[6.0]
  def change
    create_table :operations do |t|
      t.references :test_case, null: false, foreign_key: true
      t.string :operation_type, null: false
      t.integer :number, null: false
      t.text :operation_json

      t.timestamps
    end

    add_index :operations, :number
    add_index :operations, :operation_type
  end
end
