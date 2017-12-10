class SubscriptionTypeController < ApplicationController
  def index
    @subscriptions = SubscriptionType.all
  end
end