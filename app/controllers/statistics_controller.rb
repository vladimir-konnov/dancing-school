class StatisticsController < ApplicationController
  authorize_superadmin!

  before_action :init_dates

  def show
    @students = StudentsDensityService.new(current_user).density_per_period(@from, @to)
    @students_visits = StudentVisitsService.visits_per_period(@from, @to)
  end

  private

  def init_dates
    @from = Date.parse(params[:from]) rescue nil
    @to = Date.parse(params[:to]) rescue nil
    @to = Date.today.beginning_of_month if @to.nil?
    @from = @to - 1.month if @from.nil?
  end
end
