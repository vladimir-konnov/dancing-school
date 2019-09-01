class StudentVisitsService
  def self.visits_per_period(from, to)
    result = {}
    LessonStudent.joins(:lesson).where('lessons.date between ? AND ?', from, to).
        where('subscription_id is not null').group('lessons_students.student_id').
        select('lessons_students.student_id, count(lessons_students.student_id) as visits').
        order('count(lessons_students.student_id) DESC').each do |row|
      result[row.student_id] = row.visits
    end
    students = Hash[Student.where(id: result.keys).map { |s| [s.id, s] }]
    Hash[result.map { |sid, visits| [students[sid], visits] }]
  end
end
