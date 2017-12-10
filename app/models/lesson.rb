class Lesson < ApplicationRecord
  belongs_to :course, required: true, inverse_of: :lessons
  has_many :lesson_students, class_name: 'LessonStudent'
  has_many :students, through: :lesson_students
end
