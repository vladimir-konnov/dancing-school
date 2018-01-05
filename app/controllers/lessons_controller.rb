class LessonsController < ApplicationController
  authorize! :teacher

  before_action :load_lesson, only: [:edit, :update, :destroy, :add_student, :remove_student]

  def index
    now = Time.zone.now.to_date
    from = now - 1.month
    to = now + 2.weeks
    @lessons = Lesson.where('date BETWEEN ? AND ?', from, to).includes(:style).all
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
    @students = Student.all.order(:firstname, :lastname)
  end

  def update
    if @lesson.update_attributes(lesson_params)
      redirect_to edit_lesson_path(@lesson)
    else
      render :edit
    end
  end

  def destroy
  end

  def add_student
    student = Student.find(params[:student_id])
    return render json: { error: 'Wrong student_id' }, status: 422 if student.nil?
    @lesson.add_student student
    render partial: 'lessons/students_list', locals: { lesson: @lesson, students: @lesson.students }
  end

  def remove_student
    student = Student.find(params[:student_id])
    return render json: { error: 'Wrong student_id' }, status: 422 if student.nil?
    @lesson.remove_student student
    render partial: 'lessons/students_list', locals: { lesson: @lesson, students: @lesson.students }
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
    params.require(:lesson).permit(:date, :style_id, teacher_ids: [], student_ids: [])
  end
end
