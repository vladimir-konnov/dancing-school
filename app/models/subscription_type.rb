class SubscriptionType < ApplicationRecord
  has_many :subscriptions, inverse_of: :subscription_type, dependent: :restrict_with_exception

  validates_presence_of :name, :number_of_lessons, :cost
end
