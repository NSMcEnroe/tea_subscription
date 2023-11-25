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

  it "can raise an error if not given all the right parameters when subscribing" do
    customer = create(:customer)
    tea = create(:tea)
    
    subscription_params = ({
                    title: "White Tea Subscription",
                    price: 15.99,
                    status: 0,
                    customer_id: customer.id, 
                    tea_id: tea.id
                  })
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/subscriptions", headers: headers, params: JSON.generate(subscription: subscription_params)
    
    expect(response.status).to eq(400)
    expect(response.body).to eq("{\"errors\":\"Frequency can't be blank\"}")
  end

  it "can cancel a subscription" do
    customer = create(:customer)
    tea = create(:tea)

    id = create(:subscription, customer_id: customer.id, tea_id: tea.id, status: 0).id

    subscription_params = { status: 1 }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/subscriptions/#{id}", headers: headers, params: JSON.generate({subscription: subscription_params})
    new_subscription = Subscription.find_by(id: id)

    expect(response).to be_successful
    expect(new_subscription.status).to_not eq("active")
    expect(new_subscription.status).to eq("cancelled")
  end

  it "raises an error if an error occurs while cancelling a subscription" do
    customer = create(:customer)
    tea = create(:tea)

    id = create(:subscription, customer_id: customer.id, tea_id: tea.id, status: 0).id

    subscription_params = { status: 1 }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/subscriptions/20000", headers: headers, params: JSON.generate({subscription: subscription_params})

    expect(response.status).to eq(422)
    expect(response.body).to eq("{\"error\":\"Couldn't find Subscription with 'id'=20000\"}")
  end

  it "can see all of a customer's subscriptions" do
    customer = create(:customer)
    customer_2 = create(:customer)
    tea = create(:tea)
    tea_2 = create(:tea)

    subscription = create(:subscription, customer_id: customer.id, tea_id: tea.id, status: 0)
    subscription = create(:subscription, customer_id: customer.id, tea_id: tea_2.id, status: 1)

    get "/api/v1/subscriptions?customer_id=#{customer.id}"

    expect(response).to be_successful
    index = JSON.parse(response.body, symbolize_names: true)

    expect(index).to have_key :data
    expect(index[:data]).to be_an Array

    active = index[:data][0]
    cancelled = index[:data][1]

    expect(active).to have_key(:id)
    expect(active).to have_key(:type)
    expect(active[:type]).to eq("subscription")
    expect(active).to have_key(:attributes)
    expect(active[:attributes][:status]).to eq("active")
    expect(cancelled[:attributes][:status]).to eq("cancelled")
  end

  it "will return an error if it can't find the customer when looking up subscriptions" do
    customer = create(:customer)
    tea = create(:tea)
    subscription = create(:subscription, customer_id: customer.id, tea_id: tea.id, status: 0)


    get "/api/v1/subscriptions?customer_id=20000"
    expect(response.status).to eq(400)
    expect(response.body).to eq("{\"error\":\"Couldn't find Customer with 'id'=20000\"}")
  end
end