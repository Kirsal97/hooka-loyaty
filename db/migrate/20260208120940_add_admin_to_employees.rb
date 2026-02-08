class AddAdminToEmployees < ActiveRecord::Migration[8.1]
  def change
    add_column :employees, :admin, :boolean, default: false, null: false
  end
end
