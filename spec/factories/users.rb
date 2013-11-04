# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "nname"
    sequence :email do |n|
      "person#{n}@example.com"
    end

    password "12345678"
  end
end
