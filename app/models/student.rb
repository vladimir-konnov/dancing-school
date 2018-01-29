class Student < ApplicationRecord
  has_many :subscriptions, class_name: 'Subscription', inverse_of: :student, dependent: :restrict_with_exception
  has_many :lesson_students, class_name: 'LessonStudent'
  has_many :lessons, through: :lesson_students

  validates_presence_of :firstname, :lastname

  def current_subscription
    subscriptions.active.first
  end

  def subscription_for_date(date)
    subscriptions.active_for_date(date).first
  end

  def name
    "#{firstname} #{lastname}"
  end

  def official_name
    "#{lastname} #{firstname}"
  end
end
