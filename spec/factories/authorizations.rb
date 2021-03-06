# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authorization do
    provider "facebook"
    sequence(:uid)  { |n| "uid#{n}" }
    user
  end
end
