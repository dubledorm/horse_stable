class CreateUserToUserGroup < ActiveRecord::Migration[6.0]
  def change
    create_table :user_to_user_groups do |t|
      t.references :user, null: false, foreign_key: true
      t.references :user_group, null: false, foreign_key: true
      t.string :access_right

      t.timestamps
    end
  end
end
