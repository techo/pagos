# encoding: utf-8

module Page
  class Profile < Spinach::FeatureSteps
    def initialize
      visit users_path
    end

    def change_role_to(role, user)
      select(role, from: "user_#{user.id}_role")
      click_on "Grabar"
    end
  end
end