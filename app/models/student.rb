class Student < ApplicationRecord
  has_many :subscriptions, inverse_of: :student, dependent: :restrict_with_exception
  has_many :lesson_students, class_name: 'LessonStudent'
  has_many :lessons, through: :lesson_students

  validates_presence_of :firstname, :lastname

  def current_subscription
    subscriptions.active.first
  end
end
