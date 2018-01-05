class AddUserToSubscription < ActiveRecord::Migration[5.1]
  def change
    add_column :subscription_types, :duration_months, :integer, null: false, default: 0
    add_column :subscription_types, :duration_weeks, :integer, null: false, default: 4

    remove_column :subscriptions, :finished, :boolean
    add_reference :subscriptions, :user, null: false, index: true
    add_foreign_key :subscriptions, :users
    add_column :subscriptions, :no_expiry, :boolean, null: false, default: false
  end
end
