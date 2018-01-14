module Concerns::Authorizable
  extend ActiveSupport::Concern

  NotAuthorized = Class.new(StandardError)

  included do
    rescue_from NotAuthorized do |exception|
      render_not_authorized status: 403, text: 'Forbidden'
    end
  end

  private

  def admin?
    current_user&.admin?
  end

  def teacher?
    current_user&.teacher?
  end

  def render_not_authorized(status:, text:, file: '/public/403.html')
    respond_to do |format|
      format.json { render json: { message: "#{status} #{text}" }, status: status }
      format.html { render file: file, status: status, layout: false }
      format.any  { head status }
    end
  end

  module ClassMethods
    def authorize!(role, options = {})
      before_action options do
        raise NotAuthorized unless current_user&.has_role?(role)
      end
    end

    def authorize_superadmin!(options = {})
      before_action options do
        raise NotAuthorized unless current_user&.administrator_user?
      end
    end
  end
end
