FactoryGirl.define do
  factory :cooper do
    fname { Faker::Name.first_name }
    lname { Faker::Name.last_name }
    house { House.foster }
    number { "+1#{rand(10 ** 10).to_s.rjust(10, '0')}" }
    uid { Faker::Number }
    sms_confirmed true
    sms_confirmation_code "1234"
    current_member true
  end

  factory :elmwooder, parent: :cooper do
    house { House.elmwood }
  end

  factory :late_plate do
    date { (rand(14) + 1).days.from_now }

    trait :for_today do
      date { Date.today }
    end

    trait :past do
      date { (rand(14) + 1).days.ago }
    end
  end

  factory :repeat_plate do
    day { rand(7) }
  end
end
