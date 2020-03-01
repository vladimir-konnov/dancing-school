class SubscriptionType < ApplicationRecord
  has_many :subscriptions, inverse_of: :subscription_type, dependent: :restrict_with_exception

  validates_presence_of :name, :number_of_lessons, :cost, :duration_months, :duration_weeks
  validates_inclusion_of :active, in: [true, false]
  validates_numericality_of :number_of_lessons, greater_than: 0
  validates_inclusion_of :visible, :party_practice, in: [true, false]

  scope :visible, -> { where(visible: true) }
  scope :visible_for_user, -> (user) { visible unless user.administrator_user? }
end
