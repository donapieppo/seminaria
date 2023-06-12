FactoryBot.define do
  factory :conference do
    organization
    user
    sequence(:title) { |n| "conf title #{n}" }
    start_date { Date.today + 20.day }
    end_date { Date.today + 22.day }
  end
end
