class ChangeProjectReferencesInExperiment < ActiveRecord::Migration[6.0]
  PROJECT_NAME = 'FirstProject_skjvhdaslvghdkasbgvkdbhfkf'.freeze

  def up
    project = Project.create(name: PROJECT_NAME)
    Experiment.all.each do |experiment|
      experiment.project = project
      experiment.save
    end

    change_table :experiments do |t|
      t.change :project_id, :bigint, null: false
    end
  end

  def down
    change_table :experiments do |t|
      t.change :project_id, :bigint, null: true
    end
  end
end
