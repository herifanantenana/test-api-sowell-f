FactoryBot.define do
  factory :visit_prop do
    is_missing { false }
    checkpoint
    place { association :place, company: checklist.company }
    residence { association :residence, company: checklist.company }
    spot { association :spot, place: place }
  end
end
