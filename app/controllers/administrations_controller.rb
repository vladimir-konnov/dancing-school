class AdministrationsController < ApplicationController
  authorize! :admin
  before_action :init_user, only: [:update]

  def show
    @users = User.ordinary_users#.where.not(id: current_user.id)
  end

  def update
    @user.role_ids = user_params[:role_ids].reject { |role_id| role_id.blank? }
    render json: { result: :ok }
  end

  private

  def init_user
    @user = User.find_by_id user_params[:id]
    redirect_to administration_path if @user.nil?
  end

  def user_params
    params.require(:user).permit(:id, role_ids: [])
  end
end
