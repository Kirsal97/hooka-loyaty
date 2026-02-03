class CreatePurchases < ActiveRecord::Migration[8.1]
  def change
    create_table :purchases do |t|
      t.references :client, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.boolean :is_reward, null: false, default: false
      t.string :note

      t.timestamps
    end
  end
end
