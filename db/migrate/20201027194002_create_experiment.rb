class CreateExperiment < ActiveRecord::Migration[6.0]
  def change
    create_table :experiments do |t|
      t.string :human_name
      t.text :human_description
      t.references :user, null: false, foreign_key: true
      t.string :state, null: false

      t.timestamps
    end
  end
end
