class Subscription < ApplicationRecord
  belongs_to :creator, required: true, class_name: 'User', inverse_of: :subscriptions_created, foreign_key: :user_id
  belongs_to :subscription_type, required: true, inverse_of: :subscriptions
  belongs_to :student, required: true, class_name: 'Student', inverse_of: :subscriptions
  #belongs_to :paired_with, required: false, class_name: 'Subscription', inverse_of: :paired_subscription
  #has_one :paired_subscription, required: false, class_name: 'Subscription', inverse_of: :paired_with,
  #        foreign_key: :paired_with_id, dependent: :nullify
  has_many :lesson_students, class_name: 'LessonStudent', inverse_of: :subscription, dependent: :nullify
  has_many :lessons, through: :lesson_students

  #accepts_nested_attributes_for :paired_subscription

  validates_presence_of :name, :purchase_date, :price, :creator, :number_of_lessons, :lesson_price,
                        :student, :subscription_type
  validates_inclusion_of :no_expiry, in: [true, false]
  validates_presence_of :expiry_date, unless: :no_expiry?
  validates_numericality_of :number_of_lessons, greater_than: 0
  validate do |subscription|
    subscription.errors[:base] << ' Количество уроков меньше нуля' if subscription.lessons_left < 0
  end
  #validate if: -> { student.present? && subscription_type.present? && purchase_date.present? } do |subscription|
  #  exists = if subscription.no_expiry?
  #             student.subscriptions.where.not(id: subscription.id).exists?([
  #               #"expiry_date + interval '1 day' > ? OR no_expiry", subscription.purchase_date
  #               'expiry_date > ? OR no_expiry', subscription.purchase_date
  #             ])
  #           else
  #             student.subscriptions.where.not(id: subscription.id).exists?([
  #               #"(expiry_date + INTERVAL '1 day' > ? OR no_expiry) AND purchase_date - INTERVAL '1 day' < ?",
  #               '(expiry_date > ? OR no_expiry) AND purchase_date < ?',
  #               subscription.purchase_date, subscription.expiry_date
  #             ])
  #           end
  #  subscription.errors[:base] << 'Абонемент пересекается с другими абонементами' if exists
  #end

  scope :active_for_date, -> (date, is_party = false) {
    where('purchase_date <= :date AND (no_expiry OR expiry_date >= :date)', date: date)
      .joins(:subscription_type)
      .where("subscription_types.party_practice = :is_party", is_party: is_party)
      .where("subscriptions.number_of_lessons > (#{LessonStudent.where('subscription_id = subscriptions.id').select('COUNT(1)').to_sql})")
      .order(purchase_date: :asc)
  }

  scope :active, -> { active_for_date(Time.zone.now.to_date) }

  scope :overdue, -> (expiry_date = nil) {
    expiry_date ||= Date.today
    where('NOT no_expiry AND expiry_date < ?', expiry_date).
      where("number_of_lessons - (#{LessonStudent.select('COUNT(*)').where('subscription_id = subscriptions.id and student_id = subscriptions.student_id').to_sql}) > 0").
      order(purchase_date: :desc)
  }

  def lessons_left
    number_of_lessons - lessons_visited
  end

  def lessons_left=(lessons)
    self.number_of_lessons = lessons_visited + lessons.to_i
  end

  def lessons_visited
    lesson_students.count
  end

  def expired?
    !no_expiry && expiry_date < Time.zone.now.to_date
  end

  def update_missing_lessons
    unless expired? || lessons_left <= 0
      lessons = student.lessons.where('date >= ?', purchase_date).where('lessons_students.subscription_id IS NULL')
                  .joins(:style)
                  .where('styles.party_practice = :party_practice', party_practice: subscription_type.party_practice?)
      lessons = lessons.where('date <= ?', expiry_date) unless no_expiry?
      ids = lessons.order(date: :asc).limit(lessons_left).pluck(:id)
      student.lesson_students.where(lesson_id: ids).update_all(subscription_id: id)
    end
  end
end
