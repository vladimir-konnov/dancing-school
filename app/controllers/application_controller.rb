class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :masquerade_user!
  before_action :authenticate_user!

  include Authorizable
  include ApplicationHelper
end
