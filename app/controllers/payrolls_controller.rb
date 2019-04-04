class PayrollsController < ApplicationController
  authorize! :teacher

  def index
    now = Time.zone.now.to_date
    month, year = params[:month]&.split('_')&.map(&:to_i) rescue nil
    year = now.year if year.nil? || year < 2014
    month = now.month if month.nil? || month < 1 || month > 12
    @date = Date.new(year, month, 1).beginning_of_month
    @months = Lesson.select(:date).group(:date).order(:date).map(&:date).map(&:beginning_of_month).uniq{|d| [d.month, d.year]}
    @payroll = PayrollsService.new(current_user, @date).payroll
    @subscriptions = Subscription.where(user_id: @payroll.keys.map(&:id))
                       .where('purchase_date > ? and purchase_date <= ?', @date, @date.end_of_month)
                       .order(:purchase_date).preload(:student)#.preload(:creator)
    @subscriptions = @subscriptions.group_by(&:creator)
  end
end
