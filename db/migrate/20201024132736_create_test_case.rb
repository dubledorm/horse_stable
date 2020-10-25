class CreateTestCase < ActiveRecord::Migration[6.0]
  def change
    create_table :test_cases do |t|
      t.string :human_name
      t.text :desription
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
