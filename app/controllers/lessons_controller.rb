class LessonsController < ApplicationController
  authorize! :teacher

  before_action :load_lesson, only: [:edit, :update, :show, :destroy, :clone_lesson, :add_student, :remove_student]

  def index
    @from = Date.parse(params[:from]) rescue nil
    @from = Time.zone.now.to_date - 1.month if @from.nil?
    @to = Date.parse(params[:to]) rescue nil
    @to = @from + 1.month + 2.weeks if @to.nil?
    @style_id = params[:style_id]
    @lessons = Lesson.where('date BETWEEN ? AND ?', @from, @to).joins(:style).order(date: :desc).order('styles.name ASC')
    @lessons = @lessons.joins(:teachers).where('users.id': current_user) unless current_user.administrator_user?
    @lessons = @lessons.where(style_id: @style_id) if @style_id.present?
    @lessons_revenue = Hash[@lessons.joins(:subscriptions).select('SUM(lesson_price) as price, lessons.id')
                         .group('lessons.id, styles.name').map { |lesson|
      [lesson.id, lesson.price * PayrollsService.salary_percent]
    }]
    @lesson_students = @lessons.joins(:lesson_students)
    @lesson_students_count = Hash[@lesson_students.select('COUNT(1) as count, lessons.id')
                               .group('lessons.id, styles.name').map { |lesson| [lesson.id, lesson.count] }]
    @without_subscription = @lesson_students.where('lessons_students.subscription_id': nil)
                              .select('lessons.id').group('lessons.id, styles.name').pluck(:id)
    @lessons = @lessons.includes(:style, :teachers)
  end

  def new
    style = Style.find_by_id params[:style_id]
    @lesson = Lesson.new(date: Date.today, style: style, teacher_ids: style&.teacher_ids || [])
  end

  def create
    @lesson = Lesson.new(lesson_params)
    if @lesson.valid?
      @lesson.save
      redirect_to edit_lesson_path(@lesson)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @lesson.update(lesson_params)
      redirect_to lesson_path(@lesson)
    else
      render :edit
    end
  end

  def show
  end

  def destroy
  end

  def clone_lesson
    @lesson.clone_lesson
    redirect_to request.referer
  end

  def add_student
    if params[:student_id].present?
      student_id, subscription_id = params[:student_id].split('_')
      student = Student.find(student_id)
      return render json: { error: 'Wrong student_id' }, status: 422 if student.nil?
      @lesson.add_student student, student.subscriptions.where(id: subscription_id).first
    end
    render partial: 'lessons/students_list', locals: { lesson: @lesson }
  end

  def remove_student
    student = Student.find(params[:student_id])
    return render json: { error: 'Wrong student_id' }, status: 422 if student.nil?
    @lesson.remove_student student
    render partial: 'lessons/students_list', locals: { lesson: @lesson }
  end

  private

  def load_lesson
    @lesson = Lesson.find(lesson_id)
    redirect_to lessons_path if @lesson.nil?
  end

  def lesson_id
    @lesson_id ||= params[:id]
  end

  def lesson_params
    params.require(:lesson).permit(:date, :style_id, teacher_ids: [])
  end
end
