class Lesson < ApplicationRecord
  belongs_to :style, required: true, inverse_of: :lessons
  has_many :lesson_students, class_name: 'LessonStudent'
  has_many :students, through: :lesson_students
  has_many :subscriptions, through: :lesson_students
  has_and_belongs_to_many :teachers, class_name: 'User', inverse_of: :lessons

  validates_presence_of :date, :teachers

  def add_student(student, subscription)
    unless lesson_students.exists?(student: student) ||
        subscription.present? && style.party_practice? != subscription.subscription_type.party_practice?
      lesson_students.create(student: student, subscription: subscription)
      #lesson_students.create(student: student, subscription: student.subscription_for_date(date) || student.current_subscription)
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

  def clone_lesson
    lesson = Lesson.new(style: style, date: date)
    teachers.each { |teacher| lesson.teachers << teacher }
    lesson.save
    lesson_students.each do |lesson_student|
      subscription = lesson_student.subscription
      subscription = nil if subscription.present? && subscription.lessons_left <= 0
      lesson.add_student(lesson_student.student, subscription)
    end
    lesson
  end
end
