class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :masquerade_user!

  include Concerns::Authorizable
end
