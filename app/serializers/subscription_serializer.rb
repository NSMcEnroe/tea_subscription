class SubscriptionSerializer
  include JSONAPI::Serializer
  attributes :title, :description, :status, :frequency, :customer_id, :tea_id
end