class SubscriptionTypesController < ApplicationController
  authorize! :admin

  before_action :init_subscription_type, only: %i[edit update destroy]

  def index
    @subscription_types = SubscriptionType.all.preload(:subscriptions)
  end

  def new
    @subscription_type = SubscriptionType.new
  end

  def create
    @subscription_type = SubscriptionType.new(subscription_type_params)
    if @subscription_type.valid?
      @subscription_type.save
      redirect_to edit_subscription_type_path(@subscription_type)
    else
      render 'subscription_types/new'
    end
  end

  def edit
  end

  def update
    if @subscription_type.update_attributes(subscription_type_params)
      redirect_to subscription_types_path
    else
      render 'subscription_types/edit'
    end
  end

  def destroy
    @subscription_type.destroy if @subscription_type.subscriptions.length <= 0
    redirect_to subscription_types_path
  end

  private

  def init_subscription_type
    @subscription_type = SubscriptionType.find params[:id]
    redirect_to :index if @subscription_type.nil?
  end

  def subscription_type_params
    params.require(:subscription_type).permit(:name, :number_of_lessons, :cost, :duration_months, :duration_weeks, :active)
  end
end
