class AddStyleVisibleCheckbox < ActiveRecord::Migration[5.2]
  def change
    add_column :styles, :visible, :boolean, null: false, default: true
  end
end
