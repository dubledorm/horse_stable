class AddSetsOfVariablesJsonToExperiment < ActiveRecord::Migration[6.0]
  def change
    add_column :experiments, :sets_of_variables_json, :string
  end
end
