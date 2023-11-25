FactoryBot.define do
  factory :subscription do
    association :customer
    association :tea
    title { Faker::Lorem.word }
    price { Faker::Commerce.price(range: 0..30.0, as_string: true) }
    status { [0,1].sample }
    frequency { [7,14,30,60].sample }
  end
end
