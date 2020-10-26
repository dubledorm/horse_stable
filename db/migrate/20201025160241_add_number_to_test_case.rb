class AddNumberToTestCase < ActiveRecord::Migration[6.0]
  def change
    add_column :test_cases, :number, :integer, null: false

    add_index :test_cases, :number
  end
end
