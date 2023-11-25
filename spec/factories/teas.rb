FactoryBot.define do
  factory :tea do
    title { Faker::Tea.variety }
    description { Faker::Lorem.wordFaker::Lorem.word}
    temperature { Faker::Number.between(from: 175, to: 212) }
    brew_time { Faker::Number.between(from: 3, to: 10) }
  end
end
