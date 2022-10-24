class AddProjectToExperiment < ActiveRecord::Migration[6.0]
  def change
    add_reference :experiments, :project, null: true, foreign_key: true
  end
end
