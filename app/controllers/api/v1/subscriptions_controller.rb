class Api::V1::SubscriptionsController < ApplicationController
  def create
    new_subscription = Subscription.new(subscription_params)

    if new_subscription.save
      render json: SubscriptionSerializer.new(new_subscription), status: 201
    else 
      render json: { errors: new_subscription.errors.full_messages.to_sentence }, status: 400
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:title, :price, :status, :frequency, :customer_id, :tea_id)
  end
end