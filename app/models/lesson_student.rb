class LessonStudent < ApplicationRecord
  self.table_name = 'lessons_students'
  belongs_to :lesson, required: true, inverse_of: :lesson_students
  belongs_to :student, required: true, inverse_of: :lesson_students
  belongs_to :subscription, required: false, inverse_of: :lesson_students

  validates_uniqueness_of :student_id, scope: :lesson_id
end
