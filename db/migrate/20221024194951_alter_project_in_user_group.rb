class AlterProjectInUserGroup < ActiveRecord::Migration[6.0]
  def up
    project = Project.first
    UserGroup.all.each do |user_group|
      user_group.project = project
      user_group.save
    end

    change_table :user_groups do |t|
      t.change :project_id, :bigint, null: false
    end
  end

  def down
    change_table :user_groups do |t|
      t.change :project_id, :bigint, null: true
    end
  end
end
