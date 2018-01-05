class PayrollsController < ApplicationController
  authorize! :admin

  def index
    @date = Time.zone.now.to_date
    @payroll = ::PayrollsService.new(@date).payroll
  end
end
