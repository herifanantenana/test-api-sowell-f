FactoryBot.define do
  factory :issue_type do
    name { "MyString" }
    logo_url { "MyString" }
    company { association :company }
    location_type { association :location_type, company: company }
    base_issue_type { association :base_issue_type }
  end
end
