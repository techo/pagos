
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment do
    amount 1000
    family_id 5
    voucher "232"
    debt 10000
  end
end
