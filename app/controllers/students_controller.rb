class StudentsController < ApplicationController
  authorize! :teacher

  before_action :init_student, only: %i(edit update)

  def index
    @students = Student.all
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
    if params[:q].present?
      filter_student(params[:q]).map do |student|
        result << { value: student.id, label: "#{student.firstname} #{student.lastname}" }
      end
    end
    render json: result
  end

  private

  def filter_student(query)
    query = "%#{query&.downcase}%"
    Student.where("lower(firstname) || ' ' || lower(lastname) LIKE ?", query).order(:firstname, :lastname)
  end

  def init_student
    @student = Student.find params[:id]
    redirect_to :index if @student.nil?
  end

  def student_params
    params.require(:student).permit(:firstname, :middlename, :lastname, :phone_number, :email, :vk_profile, :comment)
  end
end
