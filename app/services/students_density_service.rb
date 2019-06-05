class StudentsDensityService
  def initialize(user)
    @user = user
  end

  def density_per_period(from, to)
    Hash[LessonStudent.joins(:lesson).where('lessons.date >= ? AND lessons.date <= ?', from, to).
      select("count(distinct lessons_students.student_id) as unique_students,
              extract('year' from date) as \"year\", extract('month' from date) as \"month\"").
      group("extract('year' from date), extract('month' from date)").map do |row|
        [Date.new(row.year.to_i, row.month.to_i, 1), row.unique_students]
    end]
  end
end
