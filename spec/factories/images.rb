# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :image do
    thing
    file File.open(File.join(Rails.root, '/spec/factories/files/image.png'))
    description "cat"
  end
end
