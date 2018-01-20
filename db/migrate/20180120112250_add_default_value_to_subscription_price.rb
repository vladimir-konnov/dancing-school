class AddDefaultValueToSubscriptionPrice < ActiveRecord::Migration[5.1]
  def change
    change_column :subscriptions, :price, :decimal, default: 0
  end
end
