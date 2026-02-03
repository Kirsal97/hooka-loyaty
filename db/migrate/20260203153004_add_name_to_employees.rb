class AddNameToEmployees < ActiveRecord::Migration[8.1]
  def change
    add_column :employees, :name, :string, default: '', null: false
  end
end
