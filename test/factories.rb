FactoryGirl.define do
  factory :cooper do
    fname "Chip"
    lname "Witly"
    house { House.foster }
    sequence(:number) { "+1914406#{rand(9999).to_s.rjust(4, "0")}" }
    uid "123456789"
    sms_confirmed true
    sms_confirmation_code "1234"
  end

  factory :elmwooder, parent: :cooper do
    house { House.elmwood }
  end
end
