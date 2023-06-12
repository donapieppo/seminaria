FactoryBot.define do
  factory :seminar do
    organization
    user
    date { Date.today + 20.day }
    duration { 120 }
    speaker { "speaker name surname" }
    speaker_title { "Prof." }
    title { "Titolo di questo seminario" }
  end
end
