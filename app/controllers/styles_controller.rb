class StylesController < ApplicationController
  authorize! :admin

  before_action :init_style, only: %i[edit update destroy visits]

  def index
    @styles = Style.all
  end

  def new
    @style = Style.new
  end

  def create
    @style = Style.new(style_params)
    if @style.valid?
      @style.save
      redirect_to edit_style_path(@style)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @style.update_attributes(style_params)
      redirect_to styles_path
    else
      render :edit
    end
  end

  def destroy
    @style.destroy if @style.lessons.length <= 0
    redirect_to styles_path
  end

  def visits
    @from = Date.parse(params[:from]) rescue nil
    @from = Time.zone.now.to_date - 1.month if @from.nil?
    @to = Date.parse(params[:to]) rescue nil
    @to = @from + 1.month if @to.nil?
    @to = @from if @to < @from
    @lessons = @style.lessons.where(date: (@from..@to)).order(:date).preload(:students)
    @lesson_student_matrix = {}
    @lessons.each do |lesson|
      lesson.students.each do |student|
        lesson_student_dates = @lesson_student_matrix[student]
        lesson_student_dates = @lesson_student_matrix[student] = {} if lesson_student_dates.nil?
        lesson_student_dates[lesson.date] = 0 if lesson_student_dates[lesson.date].nil?
        lesson_student_dates[lesson.date] += 1
      end
    end
  end

  private

  def init_style
    @style = Style.find params[:id]
    redirect_to :index if @style.nil?
  end

  def style_params
    p = params.require(:style).permit(:name, :duration_hours, :calculate_payrolls, teacher_ids: [])
    p[:teacher_ids] = p[:teacher_ids].reject(&:blank?)
    p
  end
end
