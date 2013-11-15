# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :thing do
    sequence :name do |n|
      "jawbon#{n}"
    end
    summary "Activity Tracker"
    introduction "Discover the unparalleled technical innovation, ease-of-use, and sophisticated design of Jawbone wearable technology and audio devices"
    after(:build) do |thing, eval|
      thing.images << FactoryGirl.build(:image, thing: thing)
    end
    video "http://www.youtube.com/embed/dFVxGRekRSg"
    user
  end
end
