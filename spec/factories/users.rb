# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "nname"
    image "http://graph.facebook.com/100003537136773/picture?type=square"
    url "https://www.facebook.com/test"
    sequence :email do |n|
      "person#{n}@example.com"
    end

    password "12345678"
  end
end
