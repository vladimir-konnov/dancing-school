class RootController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def help
  end
end
