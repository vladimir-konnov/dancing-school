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

  def hide_user
    permitted_params = params.permit(:id, :hidden)
    user_id = permitted_params[:id]
    if user_id.present?
      user = User.find user_id
      if user.present?
        user.update(hidden: permitted_params[:hidden] == 'true')
        return render json: { hidden: user.hidden? }
      end
    end
    render json: {}, status: :unprocessable_entity
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
