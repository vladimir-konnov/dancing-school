class Lesson < ApplicationRecord
  belongs_to :style, required: true, inverse_of: :lessons
  has_many :lesson_students, class_name: 'LessonStudent'
  has_many :students, through: :lesson_students
  has_many :subscriptions, through: :lesson_students
  has_and_belongs_to_many :teachers, class_name: 'User', inverse_of: :lessons

  validates_presence_of :date, :teachers

  def add_student(student)
    unless lesson_students.exists?(student: student)
      lesson_students.create(student: student, subscription: student.subscription_for_date(date))
    end
  end

  def remove_student(student)
    if lesson_students.exists?(student: student)
      lesson_students.where(student: student).delete_all
    end
  end

  def revenue
    subscriptions.pluck(:lesson_price).sum
  end
end
