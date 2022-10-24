class AddProjectToUserGroup < ActiveRecord::Migration[6.0]
  def change
    add_reference :user_groups, :project, null: true, foreign_key: true
  end
end
