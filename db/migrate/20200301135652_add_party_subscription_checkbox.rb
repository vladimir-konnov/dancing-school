class AddPartySubscriptionCheckbox < ActiveRecord::Migration[6.0]
  def change
    add_column :subscription_types, :party_subscription, :boolean, null: false, default: false
    add_column :styles, :party_subscription, :boolean, null: false, default: false
  end
end
