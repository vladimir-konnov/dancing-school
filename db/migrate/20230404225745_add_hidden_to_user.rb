class AddHiddenToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :hidden, :boolean, null: false, default: false
  end
end
