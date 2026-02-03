class AddPurchaseCountersToClients < ActiveRecord::Migration[8.0]
  def up
    add_column :clients, :purchases_count, :integer, default: 0, null: false
    add_column :clients, :paid_purchases_count, :integer, default: 0, null: false
    add_column :clients, :reward_purchases_count, :integer, default: 0, null: false

    Client.reset_column_information
    Client.find_each do |client|
      Client.reset_counters(client.id, :purchases)
      client.update_columns(
        paid_purchases_count: client.purchases.paid.count,
        reward_purchases_count: client.purchases.rewards.count
      )
    end
  end

  def down
    remove_column :clients, :purchases_count
    remove_column :clients, :paid_purchases_count
    remove_column :clients, :reward_purchases_count
  end
end
