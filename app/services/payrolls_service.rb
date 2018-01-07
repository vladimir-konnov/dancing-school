class PayrollsService
  DANDANCE_PERCENT = 20

  def initialize(date)
    @date = date
  end

  def payroll
    start_date = @date.beginning_of_month
    end_date = @date.end_of_month
    lessons = Lesson.where('date BETWEEN ? AND ?', start_date, end_date).preload(:teachers)
    teachers = lessons.map(&:teachers).flatten.uniq
    payroll = Hash[teachers.map { |teacher| [teacher, 0] }]
    lessons.each do |lesson|
      lesson.lesson_students.joins(:subscription).preload(:subscription).each do |lesson_student|
        teacher_salary = lesson_student.subscription.lesson_price * PayrollsService.salary_percent / lesson.teachers.count
        lesson.teachers.each { |teacher| payroll[teacher] += teacher_salary }
      end
    end
    payroll
  end

  def self.salary_percent
    @salary_percent ||= 1 - DANDANCE_PERCENT / 100.0
  end
end
