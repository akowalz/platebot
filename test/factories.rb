FactoryGirl.define do
  factory :cooper do
    fname { Faker::Name.first_name }
    lname { Faker::Name.last_name }
    house { House.foster }
    number { Faker::PhoneNumber.cell_phone }
    uid { Faker::Number }
    sms_confirmed true
    sms_confirmation_code "1234"
  end

  factory :elmwooder, parent: :cooper do
    house { House.elmwood }
  end
end
