class Api::V1::SubscriptionsController < ApplicationController
  def create
    new_subscription = Subscription.new(subscription_params)

    if new_subscription.save
      render json: SubscriptionSerializer.new(new_subscription), status: 201
    else 
      render json: { errors: new_subscription.errors.full_messages.to_sentence }, status: 400
    end
  end

  def update
    begin
      subscription = Subscription.find(params[:id])
      subscription.update(status: params[:status])
      render json: SubscriptionSerializer.new(Subscription.update(params[:id], subscription_params))
    rescue StandardError => e
      render json: { error: e.message }, status: 422
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:title, :price, :status, :frequency, :customer_id, :tea_id)
  end
end