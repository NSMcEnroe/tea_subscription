require "rails_helper"

RSpec.describe "Items API" do
  it "can create a subscription" do
    customer = create(:customer)
    tea = create(:tea)
    
    subscription_params = ({
                    title: "White Tea Subscription",
                    price: 15.99,
                    status: 0,
                    frequency: 60,
                    customer_id: customer.id, 
                    tea_id: tea.id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/subscriptions", headers: headers, params: JSON.generate(subscription: subscription_params)
    created_subscription = Subscription.last
  
    expect(response).to be_successful
    expect(created_subscription.title).to eq("White Tea Subscription")
    expect(created_subscription.price).to eq(15.99)
    expect(created_subscription.status).to eq("active")
    expect(created_subscription.frequency).to eq(60)
    expect(created_subscription.customer_id).to eq(subscription_params[:customer_id])
    expect(created_subscription.tea_id).to eq(subscription_params[:tea_id])
  end

  xit "can cancel a subscription" do
  end

  xit "can see all of a customer's subscriptions" do
  end
end