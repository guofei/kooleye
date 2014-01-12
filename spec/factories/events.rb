# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    content "MyText event"
    summary "MyString event"
    day 10
  end
end
