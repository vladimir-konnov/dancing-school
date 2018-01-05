class AddActiveToSubscriptionType < ActiveRecord::Migration[5.1]
  def change
    drop_join_table :lessons, :teachers
    drop_table :teachers
    add_column :users, :firstname, :string, null: false
    add_column :users, :lastname, :string, null: false
    add_column :users, :middlename, :string
    add_column :users, :banned, :boolean, null: false, default: false
    add_column :users, :comment, :text
    create_join_table :lessons, :users do |t|
      t.index :lesson_id
      t.index :user_id
      t.index [:lesson_id, :user_id], unique: true
      t.timestamps
    end
    add_foreign_key :lessons_users, :users
    add_foreign_key :lessons_users, :lessons

    add_column :subscription_types, :active, :boolean, null: false, default: true
    add_column :styles, :calculate_payrolls, :boolean, null: false, default: true

    create_join_table :styles, :users do |t|
      t.index :style_id
      t.index :user_id
      t.index [:style_id, :user_id], unique: true
    end
    add_foreign_key :styles_users, :users
    add_foreign_key :styles_users, :styles

    remove_column :users, :admin, :boolean
    create_table :roles do |t|
      t.string :name, null: false
      t.timestamps
    end
    create_table :users_roles, id: false do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.references :role, null: false, index: true, foreign_key: true
      t.index [:user_id, :role_id], unique: true
      t.timestamps
    end
  end
end
