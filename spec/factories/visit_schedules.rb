FactoryBot.define do
  factory :visit_schedule do
    due_at { Date.today.next_month }
    place { association :place, company: checklist.company }
    checklist
    residence { association :residence, company: checklist.company }
    spot { association :spot, place: place }
  end
end
