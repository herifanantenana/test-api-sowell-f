FactoryBot.define do
  factory :export do
    name { Faker::Name.initials }
    url { Faker::Internet.url }
    status { 2 }
    params { { "key" => "value" } }
    author { association :user}
  end
end
