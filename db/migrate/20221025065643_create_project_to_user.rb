class CreateProjectToUser < ActiveRecord::Migration[6.0]
  def change
    create_table :project_to_users do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :access_right

      t.timestamps
    end
  end
end
