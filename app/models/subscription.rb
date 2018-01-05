class Subscription < ApplicationRecord
  belongs_to :user, required: true, class_name: 'User', inverse_of: :subscriptions_created
  belongs_to :subscription_type, required: true, inverse_of: :subscriptions
  belongs_to :student, required: true, class_name: 'Student', inverse_of: :subscriptions
  belongs_to :paired_with, required: false, class_name: 'Subscription', inverse_of: :paired_subscription
  has_one :paired_subscription, required: false, class_name: 'Subscription', inverse_of: :paired_with, foreign_key: :paired_with_id
  has_many :lesson_students, class_name: 'LessonStudent', inverse_of: :subscription
  has_many :lessons, through: :lesson_students

  accepts_nested_attributes_for :paired_subscription

  validates_presence_of :name, :purchase_date, :price, :user_id
  validates_presence_of :expiry_date, unless: :no_expiry?
  validates_inclusion_of :no_expiry, in: [true, false]
  validate if: -> { subscription_type.present? } do |subscription|
    subscription.errors[:base] << ' Количество уроков меньше нуля' if subscription.lessons_left < 0
  end
  validate if: -> { student.present? && purchase_date.present? } do |subscription|
    exists = if subscription.no_expiry?
               student.subscriptions.where.not(id: subscription.id).exists?([
                 'expiry_date > ? OR no_expiry', subscription.purchase_date
               ])
             else
               student.subscriptions.where.not(id: subscription.id).exists?([
                 '(expiry_date > ? OR no_expiry) AND purchase_date < ?',
                 subscription.purchase_date, subscription.expiry_date
               ])
             end
    subscription.errors[:base] << 'Абонемент пересекается с другими абонементами' if exists
  end

  scope :active, -> {
    where('purchase_date <= :date AND (no_expiry OR expiry_date >= :date)', date: Time.zone.now.to_date)
      .order(purchase_date: :asc)
  }

  def lessons_left
    subscription_type.number_of_lessons - lessons.count
  end

  def expired?
    !no_expiry && expiry_date < Time.zone.now.to_date
  end
end
