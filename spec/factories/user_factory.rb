FactoryGirl.define do
  factory :administrator_user, class: User do
    first_name "Suzy"
    last_name "V"
    email "suzy@v.com"
    role "administrator"
    password "1234567890"
    password_confirmation "1234567890"
  end

  factory :volunteer_user, class: User do
    first_name "Suzy"
    last_name "V"
    email "suzy@v.com"
    role "volunteer"
    password "1234567890"
    password_confirmation "1234567890"
  end
end
