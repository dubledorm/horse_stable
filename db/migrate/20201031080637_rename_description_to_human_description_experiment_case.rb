class RenameDescriptionToHumanDescriptionExperimentCase < ActiveRecord::Migration[6.0]
  def change
    rename_column :experiment_cases, :desription, :human_description
  end
end
