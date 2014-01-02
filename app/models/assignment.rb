class Assignment < ActiveRecord::Base
  validates :geography, presence: true
  validates :volunteer, presence: true
  belongs_to :volunteer
  belongs_to :geography
  validates :geography_id, :uniqueness => { :scope => :volunteer_id }
  validates :volunteer_id, :uniqueness => { :scope => :geography_id }
end
