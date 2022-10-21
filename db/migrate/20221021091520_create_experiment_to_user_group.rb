class CreateExperimentToUserGroup < ActiveRecord::Migration[6.0]
  def change
    create_table :experiment_to_user_groups do |t|
      t.references :experiment, null: false, foreign_key: true
      t.references :user_group, null: false, foreign_key: true
    end
  end
end
