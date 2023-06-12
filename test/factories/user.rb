FactoryBot.define do
  factory :user do
    upn { "name.surname123@unibo.it" }
    name { "user_name" }
    surname { "user_surname" }
  end
end
