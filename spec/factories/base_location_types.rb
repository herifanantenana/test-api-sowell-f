FactoryBot.define do
  factory :base_location_type do
    name { Faker::Name.initials }
    depth_level { rand(1..3) }
  end
end
