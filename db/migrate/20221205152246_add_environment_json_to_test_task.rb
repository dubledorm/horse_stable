class AddEnvironmentJsonToTestTask < ActiveRecord::Migration[6.0]
  def change
    add_column :test_tasks, :environment_json, :string
  end
end
