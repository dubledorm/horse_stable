class CreateTestEnvironment < ActiveRecord::Migration[6.0]
  def change
    create_table :test_environments do |t|
      t.string :name
      t.text :description
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end

    add_index :test_environments, %i[name project_id]
  end
end
