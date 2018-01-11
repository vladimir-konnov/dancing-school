class SubscriptionsController < ApplicationController
  authorize! :teacher

  before_action :init_student
  before_action :init_subscription, only: [:edit, :update, :destroy]

  def index
    @subscriptions = @student.subscriptions
  end

  def new
    now = Time.zone.now.to_date
    @subscription = @student.subscriptions.build(purchase_date: now, expiry_date: now + 1.month + 1.week)
  end

  def create
    @subscription = current_user.subscriptions_created.build(subscription_params)
    @subscription.student = @student
    construct_subscription
    if @subscription.save
      @subscription.update_missing_lessons
      redirect_to edit_student_subscription_path(@student, @subscription)
    else
      render :new
    end
  end

  def edit
  end

  def update
    #construct_subscription false
    if @subscription.update_attributes(edit_subscription_params)
      @subscription.update_missing_lessons
      redirect_to student_subscriptions_path(@student)
    else
      render :edit
    end
  end

  def destroy
    @subscription.destroy if @subscription.lesson_students.count <= 0
    redirect_to student_subscriptions_path(@student)
  end

  private

  def construct_subscription
    if @subscription.subscription_type.present?
      @subscription.name = @subscription.subscription_type.name
      @subscription.expiry_date = @subscription.purchase_date +
        @subscription.subscription_type.duration_months.months +
        @subscription.subscription_type.duration_weeks.weeks
      @subscription.price = @subscription.subscription_type.cost
      @subscription.number_of_lessons = @subscription.subscription_type.number_of_lessons
    end
    @subscription.lesson_price = @subscription.price / @subscription.number_of_lessons
=begin
    if @subscription.paired_subscription.present? && @subscription.paired_subscription.student.nil?
      @subscription.paired_subscription = nil
    end
    if @subscription.paired_subscription.present?
      #@subscription.price /= 2
      @subscription.paired_subscription.assign_attributes(
        name: @subscription.name,
        user: @subscription.user,
        price: @subscription.price,
        subscription_type: @subscription.subscription_type,
        purchase_date: @subscription.purchase_date,
        no_expiry: @subscription.no_expiry,
        expiry_date: @subscription.expiry_date
      )
    end
=end
  end

  def init_student
    @student = Student.find params[:student_id]
    redirect_to :root if @student.nil?
  end

  def init_subscription
    @subscription = @student.subscriptions.find params[:id]
    redirect_to student_subscriptions_path(@student) if @subscription.nil?
  end

  def subscription_params
    params.require(:subscription).permit(
      :subscription_type_id, :student_id, :purchase_date, :no_expiry,
      #paired_subscription_attributes: [:student_id]
    )
  end

  def edit_subscription_params
    params.require(:subscription).permit(:no_expiry, :expiry_date, :lessons_left)
  end
end
