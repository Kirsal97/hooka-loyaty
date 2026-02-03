class CreateClients < ActiveRecord::Migration[8.1]
  def change
    create_table :clients do |t|
      t.string :phone, null: false
      t.string :name, null: false

      t.timestamps
    end

    add_index :clients, :phone, unique: true
  end
end
