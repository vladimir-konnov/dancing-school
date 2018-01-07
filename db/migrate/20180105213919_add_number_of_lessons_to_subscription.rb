class AddNumberOfLessonsToSubscription < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :number_of_lessons, :integer, null: false, default: 0
    add_column :subscriptions, :lesson_price, :decimal, null: false, default: 0
  end
end
