class Subscription < ApplicationRecord
  belongs_to :subscription_type, required: true, inverse_of: :subscriptions
  belongs_to :student, required: true, inverse_of: :subscriptions
  belongs_to :paired_with, required: false, class_name: 'Subscription', inverse_of: :paired_subscription
  has_one :paired_subscription, inverse_of: :paired_with, foreign_key: :paired_with_id
  has_many :lesson_students, class_name: 'LessonStudent', inverse_of: :subscription
  has_many :lessons, through: :lesson_students

  validates_presence_of :name, :purchase_date, :price
  validates_inclusion_of :finished, in: [true, false]

  scope :active, -> { where(finished: false).where('expiry_date IS NULL OR expiry_date < ?', Time.zone.now).order(purchase_date: :asc) }
end
