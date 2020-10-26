class AddFunctionNameToOperation < ActiveRecord::Migration[6.0]
  def change
    add_column :operations, :function_name, :string
  end
end
