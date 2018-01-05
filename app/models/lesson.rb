class Lesson < ApplicationRecord
  belongs_to :style, required: true, inverse_of: :lessons
  has_many :lesson_students, class_name: 'LessonStudent'
  has_many :students, through: :lesson_students
  has_and_belongs_to_many :teachers, class_name: 'User', inverse_of: :lessons

  validates_presence_of :date, :teachers

  def add_student(student)
    unless lesson_students.exists?(student: student)
      lesson_students.create(student: student, subscription: student.current_subscription)
    end
  end

  def remove_student(student)
    if lesson_students.exists?(student: student)
      lesson_students.where(student: student).delete_all
    end
  end

  def revenue
    lesson_students.joins(subscription: :subscription_type)
      .select('sum(subscription_types.cost / subscription_types.number_of_lessons)').first.sum.to_i
  end
end
