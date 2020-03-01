class StylesController < ApplicationController
  authorize_teacher! only: %i[index visits]
  authorize! :admin, except: %i[index visits]

  before_action :init_style, only: %i[edit update destroy visits]

  def index
    @styles = if current_user.admin? || current_user.administrator_user?
      Style.all
    else
      current_user.styles
    end
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
    @lessons = @style.lessons.where(date: @from..@to).order(:date).preload(:students)
    @lesson_student_matrix = {}
    @lessons.each do |lesson|
      lesson.students.each do |student|
        lesson_student_dates = @lesson_student_matrix[student]
        lesson_student_dates = @lesson_student_matrix[student] = {} if lesson_student_dates.nil?
        lesson_student_dates[lesson.date] = 0 if lesson_student_dates[lesson.date].nil?
        lesson_student_dates[lesson.date] += 1
      end
    end
    # leaving only dates which have lessons
    @days = (@from..@to).to_a.select do |date|
      @lesson_student_matrix.detect { |(_, dates_hash)| dates_hash[date].present? }.present?
    end
  end

  private

  def init_style
    @style = Style.find params[:id]
    redirect_to :index if @style.nil?
  end

  def style_params
    p = params.require(:style).permit(:name, :duration_hours, :calculate_payrolls, :party_practice, teacher_ids: [])
    p[:teacher_ids] = p[:teacher_ids].reject(&:blank?)
    p
  end
end
