FactoryBot.define do
  factory :location_type do
    name { Faker::Name.initials }
    logo_url { "MyString" }
    company { association :company }
    nature { 0 }
    base_location_type { association :base_location_type }
  end
end
