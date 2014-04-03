# encoding: utf-8

module Page
  class Assignment < Spinach::FeatureSteps
    def initialize
      visit new_assignment_path
    end

    def provinces_listed?
      !all('option').select{|x| x.text == 'PROVINCE'}.blank?
    end

    def select_province(province)
      select(province)
    end

    def locations_listed?
      !all('option').select{|x| x.text == 'CIUDAD - LOCATION'}.blank?
    end

    def select_location(location)
      select(location)
    end

    def volunteers_associated(count)
      all("input").select{|x| x[:checked] == true}.count == count
    end

    def assign_volunteer(volunteer)
      id = volunteer.id
      all("input").select{|x| x[:value].to_i == id}.first.click
    end
  end
end
