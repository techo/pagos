FactoryGirl.define do
  factory :administrator_user, class: User do
    first_name "SuzyA"
    last_name "A"
    email "suzyA@v.com"
    role "administrador"
    password "1234567890"
    password_confirmation "1234567890"
  end

  factory :volunteer_user, class: Volunteer do
    first_name "SuzyV"
    last_name "V"
    email "suzyV@v.com"
    role "voluntario"
    password "1234567890"
    password_confirmation "1234567890"
  end

  factory :user_without_role, class: User do
    first_name "Suzy"
    last_name "W"
    email "suzyW@v.com"
    role nil
    password "1234567890"
    password_confirmation "1234567890"
  end

  factory :volunteer_additional_user, class: User do
    first_name "JuanV"
    last_name "V"
    email "juanV@v.com"
    role "voluntario"
    password "1234567890"
    password_confirmation "1234567890"
  end

end
