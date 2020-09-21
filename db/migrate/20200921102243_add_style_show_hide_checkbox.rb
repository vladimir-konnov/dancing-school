class AddStyleShowHideCheckbox < ActiveRecord::Migration[6.0]
  def change
    add_column :styles, :visible, :boolean, null: false, default: true
  end
end
