class StudentsController < ApplicationController
  authorize! :teacher

  before_action :init_student, only: %i(edit update visits)

  def index
    @students = Student.order(:lastname, :firstname)
    @lesson_student_debts = LessonStudent.where(subscription_id: nil).joins(:lesson, :student)
                              .includes(:student, lesson: :style)
                              .order('students.lastname, students.firstname, lessons.date DESC')
    @lesson_student_debts = Hash[@lesson_student_debts.group_by(&:student).map do |student, lesson_students|
      [student, lesson_students.map(&:lesson)]
    end]
    @overdue_subscriptions = Subscription.overdue.preload(:student)
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(student_params)
    if @student.valid?
      @student.save
      redirect_to edit_student_path(@student)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @student.update_attributes(student_params)
      redirect_to student_subscriptions_path(@student)
    else
      render :edit
    end
  end

  def filter
    @students = filter_student(params[:q])
    render partial: 'students/table', locals: { students: @students }
  end

  def autocomplete
    result = []
    date = Date.iso8601(params[:date]) rescue nil
    if params[:q].present? && date.present? && params[:is_party].present?
      filter_student(params[:q]).each do |student|
        subscriptions = student.subscriptions_for_date(date, params[:is_party] == 'true')
        if subscriptions.present?
          subscriptions.each do |subscription|
            result << {
              value: [student.id, subscription.id].join('_'),
              label: "#{student.official_name} (#{subscription.name} - #{pretty_print_date(subscription.purchase_date)}, осталось: #{subscription.lessons_left})"
            }
          end
        else
          result << { value: student.id, label: student.official_name }
        end
      end
    end
    render json: result
  end

  def visits
    @from = Date.parse(params[:from]) rescue nil
    @from = Time.zone.now.to_date - 1.month if @from.nil?
    @to = Date.parse(params[:to]) rescue nil
    @to = @from + 1.month if @to.nil?
    @to = @from if @to < @from
    @lessons = @student.lessons.where(date: @from..@to).order(:date).preload(:style)
    @lesson_style_matrix = {}
    @lessons.each do |lesson|
      lesson_style_dates = @lesson_style_matrix[lesson.style.name]
      lesson_style_dates = @lesson_style_matrix[lesson.style.name] = {} if lesson_style_dates.nil?
      lesson_style_dates[lesson.date] = 0 if lesson_style_dates[lesson.date].nil?
      lesson_style_dates[lesson.date] += 1
    end
    # leaving only dates which have lessons
    @days = (@from..@to).to_a.select do |date|
      @lesson_style_matrix.detect { |(_, dates_hash)| dates_hash[date].present? }.present?
    end
  end

  def export
    csv_string = if current_user.admin?
      StudentsExportService.new.export_students Student.all
    else
      ''
    end
    send_data csv_string, filename: 'students.csv'
  end

  private

  def filter_student(query)
    query = "%#{query&.downcase}%"
    Student.where("(lower(firstname) || ' ' || lower(lastname) LIKE :q) OR (lower(lastname) || ' ' || lower(firstname) LIKE :q)",
                  q: query).order(:lastname, :firstname)
  end

  def init_student
    @student = Student.find params[:id]
    redirect_to :index if @student.nil?
  end

  def student_params
    params.require(:student).permit(:firstname, :middlename, :lastname, :birthday,
                                    :phone_number, :email, :vk_profile, :comment)
  end
end
