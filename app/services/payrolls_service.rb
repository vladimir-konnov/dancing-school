class PayrollsService
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
      lesson.lesson_students.preload(subscription: :subscription_type).each do |lesson_student|
        subscription_type = lesson_student.subscription&.subscription_type
        if subscription_type.present?
          lesson_cost = subscription_type.cost / subscription_type.number_of_lessons
          payroll.each_pair { |teacher, _| payroll[teacher] += lesson_cost / teachers.count }
        end
      end
    end
    payroll
  end
end
