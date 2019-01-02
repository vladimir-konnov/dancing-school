class AddSubscriptionTypeCheckbox < ActiveRecord::Migration[5.2]
  def change
    add_column :subscription_types, :visible, :boolean, null: false, default: true
  end
end
