class StudentVisitsService
  def self.visits_per_period(from, to)
    result = {}
    LessonStudent.joins(:lesson).where('lessons.date between ? AND ?', from, to).
        where('subscription_id is not null').group('lessons_students.student_id').
        select('lessons_students.student_id, count(lessons_students.student_id) as visits').
        order('count(lessons_students.student_id) DESC, lessons_students.student_id').each do |row|
      result[row.student_id] = row.visits
    end
    students = Hash[Student.where(id: result.keys).map { |s| [s.id, s] }]
    Hash[result.map { |sid, visits| [students[sid], visits] }]
  end

  def self.missed_lessons(from, to)
    Subscription.overdue(to).where('expiry_date >= ?', from).preload(lesson_students: :student)
  end
end
