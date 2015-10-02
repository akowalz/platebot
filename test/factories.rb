FactoryGirl.define do
  factory :cooper do
    fname "Chip"
    lname "Witly"
    house House.foster
    number "+19144068888"
    uid "123456789"
  end

  factory :elmwooder, class: Cooper do
    fname "Woody"
    lname "Elm"
    house House.elmwood
    number "+14534239090"
    uid "90909090"
  end
end
