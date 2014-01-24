# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :volunteer, class: Volunteer do
    first_name "Pepe"
    last_name "Rodriguez"
    email "pepe@yahoo.com"
    role "voluntario"
    password "1234567890"
    password_confirmation "1234567890"
  end

  factory :valid_payment, class: Payment do
    amount 2
    voucher "123"
    family_id 1
  end

  factory :invalid_payment, class: Payment do
    amount 4
    date Date.today
    voucher nil
    family_id 1
  end
end
